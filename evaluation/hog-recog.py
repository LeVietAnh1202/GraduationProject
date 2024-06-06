import seaborn as sns
from matplotlib import pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, f1_score, precision_score, recall_score
from skimage import feature
from skimage.feature import hog
from skimage import exposure
import cv2
import os
import numpy as np
import tensorflow as tf
import torch
from tqdm import tqdm

data_folder = 'G:/Ki_8/DATN/MTCNN_FaceNet_SVM - Copy/aligned_img/New folder'
image_paths = []
labels = []

# Hàm tiền xử lý ảnh
def preprocess_image(image_path):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    img = cv2.resize(img, (64, 128))  # Kích thước phổ biến cho HOG
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
X_features = []
y_features = []

# Use InceptionResnetV1 to extract features
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

def compute_hog_features(images):
    features = []
    for img in images:
        hog_feature = hog(img.cpu().numpy().squeeze(), orientations=9, pixels_per_cell=(8, 8), cells_per_block=(2, 2), block_norm='L2-Hys')
        features.append(hog_feature)
    return np.array(features)

# with tf.Graph().as_default():
#     sess = gpu_configuration()
#     with sess.as_default(): 
for i in tqdm(range(0, len(image_paths), batch_size)):
    batch_paths = image_paths[i:i+batch_size]
    batch_labels = labels[i:i+batch_size]

    batch_images = []
    for image_path in batch_paths:
        img = preprocess_image(image_path)
        img_tensor = torch.tensor(img, device=device, dtype=torch.float32)

        batch_images.append(img_tensor.unsqueeze(0))  # Thêm chiều channel

    batch_tensor = torch.stack(batch_images)
    hog_features = compute_hog_features(batch_tensor)

    X_features.extend(hog_features)
    y_features.extend(batch_labels)
    
X_features = np.array(X_features)
y_features = np.array(y_features)

# Split features into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X_features, y_features, test_size=0.2, random_state=42)

# Convert labels to int for cuML
unique_labels = np.unique(y_features)
label_to_int = {label: idx for idx, label in enumerate(unique_labels)}
y_train_int = np.array([label_to_int[label] for label in y_train])
y_test_int = np.array([label_to_int[label] for label in y_test])

svm_model = SVC(kernel='linear')
svm_model.fit(X_train, y_train_int)

# Bước 4: Đánh giá mô hình
# accuracy = svm_model.score(X_test, y_test)
# print(f'Model Accuracy: {accuracy}')
# Evaluate the model
y_pred_int = svm_model.predict(X_test)
y_pred = np.array([unique_labels[idx] for idx in y_pred_int])

print(f"Accuracy: {accuracy_score(y_test, y_pred)}")
print(f"Precision: {precision_score(y_test, y_pred, average='weighted')}")
print(f"Recall: {recall_score(y_test, y_pred, average='weighted')}")
print(f"F1-score: {f1_score(y_test, y_pred, average='weighted')}")

# Tính precision, recall, và f-score
report = classification_report(y_test, y_pred)

print("Classification Report:")
print(report)

# Bước 4: Đánh giá mô hình và tạo confusion matrix
conf_matrix = confusion_matrix(y_test, y_pred)

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
