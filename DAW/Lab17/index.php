<?php
    session_start();
    
    if(isset($_SESSION["usuario"]) ) {
        header("location: login.php");    
    } else {
        
        include("partials/_header.html");
        include("partials/_home.html");
        include("partials/_footer.html");
    }
    
    
?>