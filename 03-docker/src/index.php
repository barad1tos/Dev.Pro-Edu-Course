<!DOCTYPE html>
<html lang="">
    <head>
        <meta charset="UTF-8">
        <title>Hello there</title>
        <style>
            body {
                font-family: "Arial", sans-serif;
                font-size: larger;
            }

            .center {
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
            }
        </style>
    </head>
    <body>
        <img src="https://c.tenor.com/jCmPqgkv0vQAAAAC/hello.gif" alt="Hi there!" class="center">
        <?php
        $connection = new PDO('mysql:host=mysql;dbname=test;charset=utf8', 'root', 'root');
        $query      = $connection->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'test'");
        $tables     = $query->fetchAll(PDO::FETCH_COLUMN);

        if (empty($tables)) {
            echo '<p class="center">There are no tables in database <code>test</code>.</p>';
        } else {
            echo '<p class="center">Database <code>test</code> contains the following tables:</p>';
            echo '<ul class="center">';
            foreach ($tables as $table) {
                echo "<li>$table</li>";
            }
            echo '</ul>';
        }
        ?>
    </body>
</html>