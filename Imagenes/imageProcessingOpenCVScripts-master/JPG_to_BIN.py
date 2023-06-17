import sys
import os
from PIL import Image

# Obtén la ruta del archivo .jpg del argumento de línea de comandos
archivo_jpg = sys.argv[1]

# Extrae el nombre del archivo sin la extensión .jpg
nombre_archivo = os.path.splitext(archivo_jpg)[0]

# Abre la imagen .jpg utilizando la biblioteca Pillow
imagen = Image.open(archivo_jpg)

# Convierte la imagen a escala de grises
imagen_gris = imagen.convert('L')

# Obtén los datos de píxeles de la imagen en escala de grises como una secuencia de bytes
datos_binarios = imagen_gris.tobytes()

# Ruta donde deseas guardar el archivo binario resultante
archivo_binario = nombre_archivo + '.bin'

# Guarda los datos binarios en un archivo binario
with open(archivo_binario, 'wb') as archivo:
    archivo.write(datos_binarios)

print("La conversión a binario en escala de grises se ha completado exitosamente.")
