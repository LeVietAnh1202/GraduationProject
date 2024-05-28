import streamlit as st
import os
import shutil

def main():
    st.title("Ảnh Sinh Tự Động")

    # Chỗ để chọn các ảnh mẫu
    uploaded_files = st.file_uploader("Chọn các ảnh mẫu", accept_multiple_files=True, type=["jpg", "jpeg", "png"])

    # Chỗ để đưa vào 1 loạt các đường dẫn ảnh muốn tạo
    paths_input = st.text_area("Nhập các đường dẫn ảnh muốn tạo (mỗi dòng là một đường dẫn)")

    # Chọn vị trí thư mục gốc
    root_dir = st.text_input("Chọn thư mục gốc để chứa tất cả các file và folder được sinh ra")

    # Nút generate
    if st.button("Generate"):
        if not uploaded_files or not paths_input or not root_dir:
            st.error("Vui lòng nhập đầy đủ thông tin")
        else:
            generate_images(uploaded_files, paths_input.splitlines(), root_dir)
            st.success("Quá trình sinh ảnh hoàn thành")

def generate_images(uploaded_files, paths, root_dir):
    # Lưu các ảnh mẫu vào thư mục tạm
    temp_dir = "temp_samples"
    os.makedirs(temp_dir, exist_ok=True)
    sample_images = {}
    for uploaded_file in uploaded_files:
        file_path = os.path.join(temp_dir, uploaded_file.name)
        with open(file_path, "wb") as f:
            f.write(uploaded_file.getbuffer())
        # Lấy MaSV_TenSV từ tên file
        key = os.path.splitext(uploaded_file.name)[0]
        sample_images[key] = file_path

    # Duyệt qua các đường dẫn và tạo ảnh
    for path in paths:
        parts = path.split('/')
        if len(parts) < 3:
            st.error(f"Đường dẫn không hợp lệ: {path}")
            continue

        dayID, ma_sv_ten_sv, img_name = parts[0], parts[1], parts[2]
        sample_image_path = sample_images.get(ma_sv_ten_sv)

        if sample_image_path:
            # Tạo thư mục đích nếu chưa tồn tại
            dest_dir = os.path.join(root_dir, dayID, ma_sv_ten_sv)
            os.makedirs(dest_dir, exist_ok=True)
            dest_path = os.path.join(dest_dir, img_name)
            # Copy và đổi tên ảnh
            shutil.copy(sample_image_path, dest_path)
        else:
            st.error(f"Không tìm thấy ảnh mẫu cho {ma_sv_ten_sv}")

    # Xóa thư mục tạm
    shutil.rmtree(temp_dir)

if __name__ == "__main__":
    main()
