<?php
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = htmlspecialchars(trim($_POST["username"] ?? ""));
    $password = trim($_POST["password"] ?? "");

    if (!empty($username) && !empty($password)) {
        // Example: Here you'd check hashed passwords from a DB.
        $_SESSION["username"] = $username;

        header("Location: home.php");
        exit();
    } else {
        $error = "Missing username or password.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <form method="post">
        Username:<br>
        <input type="text" name="username"><br>
        Password:<br>
        <input type="text" name="username" required><br>
        <input type="submit" name="login" value="login"><br>

    </form>
    <?php if (!empty($error)) echo "<p style='color:red;'>$error</p>"; ?>
</body>
</html>
