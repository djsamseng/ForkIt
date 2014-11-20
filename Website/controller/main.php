<?php

$current_version = 1;

if (isset($_GET["checkversion"]) && htmlspecialchars($_GET["checkversion"]) == "true" && isset($_GET["version"])) {
    $version = htmlspecialchars($_GET["version"]);
    if ($version == $current_version) {
        echo json_encode(array("update_required"=>false));
    } else {
        echo json_encode(array("update_required"=>true));
    }
    exit();
}
if (isset($_GET["updatedata"]) && htmlspecialchars($_GET["updatedata"]) == "true") {
    $json_file = file_get_contents("model/food_data.json");
    $json = json_decode($json_file, true);
    echo json_encode($json);
}
?>
