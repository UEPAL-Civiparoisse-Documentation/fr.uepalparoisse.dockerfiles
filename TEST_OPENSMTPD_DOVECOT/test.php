<?php

$c=curl_init("https://civicrm.test/index.php");
curl_setopt($c,CURLOPT_RETURNTRANSFER,true);
curl_setopt($c,CURLOPT_SSL_VERIFYPEER,true);
$ret=curl_exec($c);
$info=curl_getinfo($c);
var_dump($info);
echo "=============\n";
var_dump($ret);
