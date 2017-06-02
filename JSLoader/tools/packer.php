<?php 

const PRIVATE_KEY = <<<EOD
-----BEGIN RSA PRIVATE KEY-----
    MIICWwIBAAKBgQDF4VYuUTSYf0ShBow2Eh7yPUdq/uV+2zSrR38WBlYZ6D/7GIuX
    2rxdGRMFPqMmBRnFD/V7gwyaCO4ZxsABitQ8mhYbAgYM2QrQtHQD6/sAY/Vu/puX
    G3yKCIU+L149X65nbpzT76xnN8QmldJMOWF0DM5TLsPBLN0hBOJ/4PI0RQIDAQAB
    AoGAOAiNHOSF3kD7sBVoks8i0DmmBZhUaE2uZmoChLwamY94vqO+s6uO91XoWu3X
    ySZcm77fJrB/Wwb4VXhAWq9zVY1PAZaI/H5AGnQ1A9xw4lFub38RM3zRV9jb5gbg
    C6UJ+EsJ3XhrA0RlFDgdyd9W5AFXYk0cfVguSXK7M1qDAMECQQD/7DKmyfqe+3SP
    YIjcRGJmNuoNJBCiMYmdhncvJ9nv9yRK63gpW75P5vIK3Re1ANscS8tVeVzcSbWy
    AnRd9Bw5AkEAxfCl0U70olbAQv12rqTzGXYAjLObW8nnFpp6fECd6RYDQa4YkELe
    mjkt2YgeIHBVESDz4ZWCyqKuYQT8V3OwbQJAYvX0yCYGMX/OnLqZcYNIAXpumtI9
    VFqPekhKwgNI9M++SvIurt95AfCt26GOz0EbeR+d6tlZHR2rkr/8O3BvkQJAP6fI
    a6uMmLh1VBXXGQsK8uE0BAuuprIjku1S/qp5HgBqQ7ENTTd0BvzkddSEe8IkWUHT
    rHQ8f5YZpjHIRQd7cQJAOR5AK69V8sfacPcVO87S8A/VUKh9CVCHsoqsZUVeshlU
    /tlXadsOXw/E298/OIH7E0L9alv9MMtYyVSUAl0lHg==
-----END RSA PRIVATE KEY-----
EOD;

$files = "";
$zipFile = "script.zip";
$finalFile = "v13";
for ($i = 1; $i < count($argv); $i ++) {
    if ($argv[$i] == '-o') {
        $finalFile = $argv[$i + 1];
        break;
    }
    $files .= $argv[$i] . " ";
}

if (!empty($files)) {

    //compress files
    echo system("zip $zipFile $files"); 

    //get and encrypt zip file's md5
    $zipFileMD5 = md5_file($zipFile);
    $private_key = openssl_pkey_get_private(PRIVATE_KEY);
    $ret = openssl_private_encrypt($zipFileMD5, $encrypted, $private_key);

    if (!$ret || empty($encrypted)) {
        unlink($zipFile);
        echo "fail to encrypt file md5";
    }

    $md5File = "key";
    file_put_contents($md5File, $encrypted);

    //pack script zip file and md5 file to final zip file
    echo system("zip $finalFile $zipFile $md5File"); 

    unlink($md5File);
    unlink($zipFile);
}
