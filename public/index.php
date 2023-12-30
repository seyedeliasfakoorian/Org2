<?php

// Load the head image
$headImage = imagecreatefromjpeg('public/favicon.jpg');

// Get image dimensions
$width = imagesx($headImage);
$height = imagesy($headImage);

// Calculate the width of each piece
$pieceWidth = $width / 3;

// Create a directory to store image pieces
$directory = 'image_pieces/';
if (!file_exists($directory)) {
    mkdir($directory, 0777, true);
}

// Array to store image file names
$imageFileNames = [];

// RabbitMQ setup
$exchangeName = 'image_processing';
$queueName = 'processed_images';

$connection = new AMQPStreamConnection('localhost', 5672, 'guest', 'guest');
$channel = $connection->channel();

// Declare exchange and queue
$channel->exchange_declare($exchangeName, 'fanout', false, false, false);
$channel->queue_declare($queueName, false, false, false, false);
$channel->queue_bind($queueName, $exchangeName);

// Loop through and split the image into 12 pieces
for ($i = 0; $i < 3; $i++) {
    for ($j = 0; $j < 4; $j++) {
        // ... (existing code for image processing)

        // Push the filename to the array
        $imageFileNames[] = $filename;

        // Publish a message to RabbitMQ
        $message = new AMQPMessage(json_encode(['filename' => $filename, 'piece' => $i . '_' . $j]));
        $channel->basic_publish($message, $exchangeName);
    }
}

// Output the array of image file names (for testing purposes)
print_r($imageFileNames);

// Close RabbitMQ connection
$channel->close();
$connection->close();

// Destroy the original image
imagedestroy($headImage);
?>