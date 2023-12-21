<?php

// Load the head image
$headImage = imagecreatefrompng('public/favicon.png');

// Get image dimensions
$width = imagesx($headImage);
$height = imagesy($headImage);

// Calculate the width of each piece
$pieceWidth = $width / 3;

// Array to store image sources
$imageSources = [];

// Loop through and split the image into 12 pieces
for ($i = 0; $i < 3; $i++) {
    for ($j = 0; $j < 4; $j++) {
        // Create a new image for each piece
        $piece = imagecreatetruecolor($pieceWidth, $height / 4);

        // Copy a portion of the original image to the new piece
        imagecopy($piece, $headImage, 0, 0, $i * $pieceWidth, $j * ($height / 4), $pieceWidth, $height / 4);

        // Save the piece to a variable (base64 encoded)
        ob_start();
        imagepng($piece);
        $imageData = ob_get_contents();
        ob_end_clean();

        // Encode the image data in base64
        $base64Image = 'data:image/png;base64,' . base64_encode($imageData);

        // Push the base64 encoded image to the array
        $imageSources[] = $base64Image;
    }
}

// Output the array of base64 encoded images (for testing purposes)
print_r($imageSources);

// Destroy the original and temporary images
imagedestroy($headImage);
imagedestroy($piece);
?>
