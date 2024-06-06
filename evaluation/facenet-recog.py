from sklearn.metrics import classification_report, confusion_matrix, precision_score, recall_score, f1_score, accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
import os
import torch # type: ignore
import numpy as np
from facenet_pytorch import InceptionResnetV1, MTCNN, extract_face # type: ignore
from torchvision.transforms import functional as F # type: ignore
from PIL import Image
import tensorflow as tf
from tqdm import tqdm # type: ignore
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix

data_folder = 'G:/Ki_8/DATN/MTCNN_FaceNet_SVM - Copy/aligned_img/New folder'
image_paths = []
labels = []

# Hàm tiền xử lý ảnh
def preprocess_image(image_path):
    img = Image.open(image_path).convert('RGB')
    # img = img.resize(target_size)  # Resize image to target size
    img = F.to_tensor(img)
    # Thêm các bước tiền xử lý khác nếu cần thiết (đổi kích thước, chuẩn hóa, v.v.)
    return img

for person_folder in os.listdir(data_folder):
    person_path = os.path.join(data_folder, person_folder)
    if os.path.isdir(person_path):
        for image_name in os.listdir(person_path):
            image_path = os.path.join(person_path, image_name)
            image_paths.append(image_path)
            labels.append(person_folder)

def gpu_configuration():
    gpu_options = tf.compat.v1.GPUOptions(allow_growth=True)
    # gpu_options = tf.compat.v1.GPUOptions(per_process_gpu_memory_fraction=0.7)
    sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(gpu_options=gpu_options, log_device_placement=False))
    return sess 

# Preprocess images in batches of 200 and extract features
batch_size = 50
X_train_features = []
X_test_features = []
y_train_features = []
y_test_features = []

# Use InceptionResnetV1 to extract features

# with tf.Graph().as_default():
#     sess = gpu_configuration()
#     with sess.as_default(): 
for i in tqdm(range(0, len(image_paths), batch_size)):
    batch_paths = image_paths[i:i+batch_size]
    batch_labels = labels[i:i+batch_size]

    batch_images = []
    for image_path in batch_paths:
        img = preprocess_image(image_path)
        batch_images.append(img)

    batch_tensor = torch.stack(batch_images)
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = InceptionResnetV1(pretrained='vggface2').eval().to(device)
    
    with torch.no_grad():
        batch_tensor = batch_tensor.to(device)
        features = model(batch_tensor)
        features = features.squeeze().cpu().numpy()

    # Split features into train and test sets
    X_train_batch, X_test_batch, y_train_batch, y_test_batch = train_test_split(
        features, batch_labels, test_size=0.2, random_state=42)

    X_train_features.extend(X_train_batch)
    X_test_features.extend(X_test_batch)
    y_train_features.extend(y_train_batch)
    y_test_features.extend(y_test_batch)

    # Clear memory
    del batch_tensor
    del features

svm_model = SVC(kernel='linear')
svm_model.fit(X_train_features, y_train_features)

# Bước 4: Đánh giá mô hình
accuracy = svm_model.score(X_test_features, y_test_features)
print(f'Model Accuracy: {accuracy}')
y_pred = svm_model.predict(X_test_features)

print(f"Accuracy: {accuracy_score(y_test_features, y_pred)}")
print(f"Precision: {precision_score(y_test_features, y_pred, average='weighted')}")
print(f"Recall: {recall_score(y_test_features, y_pred, average='weighted')}")
print(f"F1-score: {f1_score(y_test_features, y_pred, average='weighted')}")

# Tính precision, recall, và f-score
report = classification_report(y_test_features, y_pred)

print("Classification Report:")
print(report)

# Bước 4: Đánh giá mô hình và tạo confusion matrix
conf_matrix = confusion_matrix(y_test_features, y_pred)

# Trực quan hóa confusion matrix
plt.figure(figsize=(10, 8))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', xticklabels=np.unique(labels), yticklabels=np.unique(labels))
plt.title('Confusion Matrix')
plt.xlabel('Predicted')
plt.ylabel('Actual')

# Lưu biểu đồ vào file
plt.savefig('confusion_matrix.png')

# Hiển thị biểu đồ
plt.show()
