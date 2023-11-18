from PIL import Image

def split_image(input_path, output_path, rows, columns, reverse=False):
    # Open the image
    original_image = Image.open(input_path)

    # Get the dimensions of the original image
    width, height = original_image.size

    # Calculate the width and height of each grid cell
    cell_width = width // columns
    cell_height = height // rows

    # Iterate through each cell and save it as a new image
    for row in range(rows):
        for col in range(columns):
            left = col * cell_width
            upper = row * cell_height
            right = left + cell_width
            lower = upper + cell_height

            # Crop the image to the current cell
            cell_image = original_image.crop((left, upper, right, lower))

            # Save the cell image
            if reverse:
                output_filename = f"{output_path}_{col}_{row}.jpg"
            else:
                output_filename = f"{output_path}_{row}_{col}.jpg"

            cell_image.save(output_filename)

if __name__ == "__main__":
    input_image_path = "public/favicon.jpg"
    output_image_path = "output_image"
    rows = 4
    columns = 4
    reverse = False

    split_image(input_image_path, output_image_path, rows, columns, reverse)