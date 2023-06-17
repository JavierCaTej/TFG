with open('3.jpg', 'rb') as file:
    binary_data = file.read()

binary_string = ''
for byte in binary_data:
    binary_string += format(byte, '08b')

with open('3.txt', 'w') as file:
    file.write(binary_string)
