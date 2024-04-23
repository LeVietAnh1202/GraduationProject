import streamlit as st

class ModelGenerator:
    def __init__(self, attributes):
        self.attributes = attributes

    def generate_model(self, class_name):
        class_definition = f"class {class_name}" + " {\n"

        for attribute, data_type in self.attributes.items():
            class_definition += f"\tfinal {data_type} {attribute};\n"

        class_definition += "\n"
        class_definition += f"\t{class_name}(" + "{\n"

        for attribute, data_type in self.attributes.items():
            class_definition += f"\t\trequired this.{attribute},\n"

        class_definition = class_definition[:-2]  # Remove the last comma and space
        class_definition += "\n\t});\n"
        class_definition += "\n"
        class_definition += "\t@override\n"
        class_definition += "\tString toString() {\n"
        class_definition += f'\t\treturn \'{" - ".join([f"${{{attribute}}}" for attribute in self.attributes.keys()])}\';\n'
        class_definition += "\t}\n"

        class_definition += "}\n"

        return class_definition

def main():
    flutter_data_types = ["String", "int", "double", "bool", "List", "Map", "DateTime", "dynamic"]
    st.title("Model Generator")

    # Tạo các cột để nhập thông tin
    with st.form("model_form"):
        st.write("Nhập thông tin cho lớp model:")
        class_name = st.text_input("Tên lớp model:")
        num_attributes = st.number_input("Số lượng thuộc tính:", min_value=1, value=1, step=1)

        attributes = {}
        for i in range(num_attributes):
            attribute_name = st.text_input(f"Tên thuộc tính {i+1}:", key=f"attribute_name_{i}")
            attribute_type = st.selectbox(f"Kiểu dữ liệu cho {attribute_name}:", options=flutter_data_types, index=0, key=f"attribute_type_{i}")
            attributes[attribute_name] = attribute_type

        st.session_state.num_attributes = num_attributes
        submitted = False
        # submitted = st.form_submit_button("Tạo lớp model")

         # Kiểm tra xem tất cả các form đã được điền đầy đủ chưa
        all_forms_filled = all(st.session_state[f"attribute_name_{i}"] for i in range(num_attributes))
        
        # Vô hiệu hóa nút submit nếu có bất kỳ form nào chưa được điền
        if not all_forms_filled:
            st.write("Vui lòng nhập đầy đủ thông tin cho tất cả các thuộc tính")
            st.form_submit_button("Tạo lớp model", disabled=True)
        else:
            submitted = st.form_submit_button("Tạo lớp model")

    if submitted:
        generator = ModelGenerator(attributes)
        model_definition = generator.generate_model(class_name)
        st.code(model_definition, language="dart")

if __name__ == "__main__":
    main()