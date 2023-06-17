import sys
import os
from PIL import Image

# Obtén la ruta del archivo binario del argumento de línea de comandos
archivo_binario = sys.argv[1]

# Extrae el nombre del archivo sin la extensión .bin
nombre_archivo = os.path.splitext(archivo_binario)[0]

# Lee los datos binarios del archivo
with open(archivo_binario, 'rb') as archivo:
    datos_binarios = archivo.read()

# Obtiene las dimensiones de la imagen original
imagen_original = Image.open("imagen.jpg")
ancho, alto = imagen_original.size

# Crea una imagen a partir de los datos binarios y las dimensiones obtenidas
imagen = Image.frombytes('RGB', (ancho, alto), datos_binarios)

# Ruta donde deseas guardar el archivo .jpg resultante
archivo_jpg = nombre_archivo + '.jpg'

# Guarda la imagen como un archivo .jpg
imagen.save(archivo_jpg)

print("La conversión a .jpg se ha completado exitosamente.")
