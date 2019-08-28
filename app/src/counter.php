<?php 

$path = './countlog';

$file  = fopen( $path, 'r' );
$count = fgets( $file, 1000 );
fclose( $file );

$count = abs( intval( $count ) ) + 1;

$file = fopen( $path, 'w' );
fwrite( $file, $count );
fclose( $file );

?>