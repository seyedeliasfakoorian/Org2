<?php

// Load the head image
$headImage = imagecreatefromjpeg('public/favicon.jpg');

// Check if the image is loaded successfully
if (!$headImage) {
    die('Error loading image');
}

// Get image dimensions
$width = imagesx($headImage);
$height = imagesy($headImage);

// Calculate the width and height of each piece
$pieceWidth = $width / 750;
$pieceHeight = $height / 667;

// Array to store image sources
$imageSources = [];

// Loop through and split the image into 12 pieces
for ($i = 0; $i < 3; $i++) {
    for ($j = 0; $j < 4; $j++) {

        // Create a new image for each piece
        $piece = imagecreatetruecolor($pieceWidth, $pieceHeight);

        // Copy a portion of the original image to the new piece
        imagecopy($piece, $headImage, 0, 0, $i * $pieceWidth, $j * $pieceHeight, $pieceWidth, $pieceHeight);

        // Save the piece to a variable (base64 encoded)
        ob_start();
        imagepng($piece);
        $imageData = ob_get_contents();
        ob_end_clean();

        // Encode the image data in base64
        $base64Image = 'data:image/jpeg;base64,' . base64_encode($imageData);

        // Push the base64 encoded image to the array
        $imageSources[] = $base64Image;

        // Destroy the piece image
        imagedestroy($piece);
    }
}

// Output the array of base64 encoded images
print_r($imageSources);

// Destroy the original image
imagedestroy($headImage);
?>
