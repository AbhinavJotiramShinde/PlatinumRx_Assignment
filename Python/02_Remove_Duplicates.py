input_string = input("Enter string: ")
unique_str = ""
for char in input_string:
    if char not in unique_str:
        unique_str += char

print(unique_str)
