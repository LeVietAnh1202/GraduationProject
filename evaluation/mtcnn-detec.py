""" import os
import cv2
import numpy as np
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from mtcnn import MTCNN
from tqdm import tqdm

def read_images_from_folder(folder_path, target_size=(224, 224)):
    images = []
    y_test = []

    for person_folder in os.listdir(folder_path):
        person_path = os.path.join(folder_path, person_folder)
        if os.path.isdir(person_path):
            for i, filename in enumerate(os.listdir(person_path), 1):
                img_path = os.path.join(person_path, filename)
                if os.path.isfile(img_path):
                    img = cv2.imread(img_path)
                    if img is not None:
                        img = cv2.resize(img, target_size)
                        images.append(img)
                        y_test.append(1)
                        print(f"Image {i}: {img_path} - Loaded successfully")
                    else:
                        print(f"Image {i}: {img_path} - Failed to read")
                else:
                    print(f"Image {i}: {img_path} - File does not exist")
        else:
            print(f"Directory {person_path} does not exist")

    return np.array(images), np.array(y_test)

mtcnn_detector = MTCNN()

def MTCNN_detector(image, detector):
    faces = detector.detect_faces(image)
    return faces

folder_path = "G:/Ki_8/DATN/MTCNN_FaceNet_SVM - Copy/train_img"
images, y_test = read_images_from_folder(folder_path)

y_pred = []

# Convert images to RGB as MTCNN expects RGB images
images_rgb = [cv2.cvtColor(image, cv2.COLOR_BGR2RGB) for image in images]

for count, image in enumerate(tqdm(images_rgb, desc="Processing images")):
    faces = MTCNN_detector(image, mtcnn_detector)
    num_faces = len(faces)
    y_pred.append(num_faces)
    print(f'DONE {count}')

y_pred = np.array(y_pred)
y_pred = np.where(y_pred == 1, 1, 0)

accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred)
recall = recall_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred)

print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("F1-Score:", f1) """

# import os
# import cv2
# import numpy as np
# from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
# from mtcnn import MTCNN
# from tqdm import tqdm
# import multiprocessing
# import tensorflow as tf
# # Set TF_FORCE_GPU_ALLOW_GROWTH to true before importing TensorFlow
# os.environ['TF_FORCE_GPU_ALLOW_GROWTH'] = 'true'
# import tensorflow as tf

# # Suppress TensorFlow warnings
# tf.get_logger().setLevel('ERROR')

# def read_images_from_folder(folder_path, target_size=(224, 224)):
#     images = []
#     y_test = []

#     for person_folder in os.listdir(folder_path):
#         person_path = os.path.join(folder_path, person_folder)
#         if os.path.isdir(person_path):
#             for i, filename in enumerate(os.listdir(person_path), 1):
#                 img_path = os.path.join(person_path, filename)
#                 if os.path.isfile(img_path):
#                     img = cv2.imread(img_path)
#                     if img is not None:
#                         img = cv2.resize(img, target_size)
#                         images.append(img)
#                         y_test.append(1)
#                         print(f"Image {i}: {img_path} - Loaded successfully")
#                     else:
#                         print(f"Image {i}: {img_path} - Failed to read")
#                 else:
#                     print(f"Image {i}: {img_path} - File does not exist")
#         else:
#             print(f"Directory {person_path} does not exist")

#     return np.array(images), np.array(y_test)

# def process_image(image, detector):
#     faces = detector.detect_faces(image)
#     return len(faces)

# def main():
#     mtcnn_detector = MTCNN()
#     folder_path = "G:/Ki_8/DATN/MTCNN_FaceNet_SVM - Copy/train_img"
#     images, y_test = read_images_from_folder(folder_path)
    
#     y_pred = []

#     # Convert images to RGB as MTCNN expects RGB images
#     images_rgb = [cv2.cvtColor(image, cv2.COLOR_BGR2RGB) for image in images]

#     # Create a multiprocessing Pool with maximum number of processes available
#     num_processes = multiprocessing.cpu_count() - 2  # Số lượng tiến trình bằng số lõi CPU
#     pool = multiprocessing.Pool(processes=num_processes)

#     # Use pool.map to apply process_image function to each image in parallel
#     results = pool.starmap(process_image, [(image, mtcnn_detector) for image in images_rgb])

#     # Close the pool of processes
#     pool.close()
#     pool.join()

#     y_pred = np.array(results)
#     y_pred = np.where(y_pred == 1, 1, 0)

#     accuracy = accuracy_score(y_test, y_pred)
#     precision = precision_score(y_test, y_pred)
#     recall = recall_score(y_test, y_pred)
#     f1 = f1_score(y_test, y_pred)

#     print("Accuracy:", accuracy)
#     print("Precision:", precision)
#     print("Recall:", recall)
#     print("F1-Score:", f1)

# if __name__ == "__main__":
#     main()

import os
import cv2
import numpy as np
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from mtcnn import MTCNN
from tqdm import tqdm

def read_images_from_folder(folder_path, target_size=(224, 224)):
    images = []
    y_test = []
    
    for person_folder in os.listdir(folder_path):
        person_path = os.path.join(folder_path, person_folder)
        if os.path.isdir(person_path):
            for i, filename in enumerate(os.listdir(person_path), 1):
                img_path = os.path.join(person_path, filename)
                if os.path.isfile(img_path):
                    img = cv2.imread(img_path)
                    if img is not None:
                        img = cv2.resize(img, target_size)
                        images.append(img)
                        y_test.append(1)
                        print(f"Image {i}: {img_path} - Loaded successfully")
                    else:
                        print(f"Image {i}: {img_path} - Failed to read")
                else:
                    print(f"Image {i}: {img_path} - File does not exist")
        else:
            print(f"Directory {person_path} does not exist")

    return np.array(images), np.array(y_test)

def MTCNN_detector(image_batch, detector):
    faces_batch = []
    for image in image_batch:
        faces = detector.detect_faces(image)
        faces_batch.append(len(faces))
    return faces_batch

def process_image_batch(images, mtcnn_detector):
    images_rgb = [cv2.cvtColor(image, cv2.COLOR_BGR2RGB) for image in images]
    return MTCNN_detector(images_rgb, mtcnn_detector)

def main():
    mtcnn_detector = MTCNN()
    folder_path = "G:/Ki_8/DATN/MTCNN_FaceNet_SVM - Copy/train_img"
    images, y_test = read_images_from_folder(folder_path)

    y_pred = []
    batch_size = 200

    for i in tqdm(range(0, len(images), batch_size)):
        batch_images = images[i:i+batch_size]
        batch_y_test = y_test[i:i+batch_size]
        batch_y_pred = process_image_batch(batch_images, mtcnn_detector)
        y_pred.extend(batch_y_pred)
        print(f'DONE {i}-{i+batch_size}')
        
        # Xóa các biến không cần thiết sau mỗi lần lặp
        del batch_images
        del batch_y_test
        del batch_y_pred

    y_pred = np.array(y_pred)
    y_pred = np.where(y_pred == 1, 1, 0)

    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred)
    recall = recall_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred)

    print("Accuracy:", accuracy)
    print("Precision:", precision)
    print("Recall:", recall)
    print("F1-Score:", f1)

    # Xóa các biến không cần thiết sau khi tính toán xong
    del images
    del y_test
    del y_pred

if __name__ == "__main__":
    main()
