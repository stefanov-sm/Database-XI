<?php
if (PHP_SAPI == 'cli' && $argc == 2 && preg_match('/^\w+$/', $argv[1])) {
  $conn = new PDO('pgsql:dbname=postgres');
  $conn -> exec("LISTEN {$argv[1]};");
  echo "Listening channel {$argv[1]} ...".PHP_EOL;

  while(true)
    if ($res = $conn -> pgsqlGetNotify(PDO::FETCH_ASSOC, 500)) {
      $msg_data = json_decode($res['payload']);

      // That's all about listening. Some "business logic" follows
      if ($msg_data -> v < 1000) continue;
      if ($msg_data -> v >= 100000) $msg_template = 'A huge one, V is %d, ID is %d';
      elseif ($msg_data -> v >= 10000) $msg_template = 'A large one, V is %d, ID is %d';
      else $msg_template = 'Big fish, V is %d, ID is %d';
      echo sprintf($msg_template, $msg_data -> v, $msg_data -> id).PHP_EOL;
    }
}
else echo 'Error: syntax';
