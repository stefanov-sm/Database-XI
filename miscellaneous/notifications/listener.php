<?php
// CLI syntax: php listener.php <channel_name>
if (PHP_SAPI == 'cli' && $argc == 2 && preg_match('/^\w+$/', $argv[1]))
{
  $conn = new PDO('pgsql:dbname=postgres');
  $conn -> exec("LISTEN {$argv[1]}; COMMIT");
  echo "Listening channel {$argv[1]} ...".PHP_EOL;
  while(true)
    if ($res = $conn -> pgsqlGetNotify(PDO::FETCH_ASSOC, 500))
      echo "Notification received. Payload: {$res['payload']}".PHP_EOL;
}
else echo 'Error: syntax';
