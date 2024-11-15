<?php
// ECB forex external table data update
// Scheduled to run daily roughly at 02:00AM

const ECB_FOREX_URL = 'https://www.ecb.europa.eu/stats/eurofxref /eurofxref-hist.zip',
      FOREIGN_DATA_FOLDER = 'c:/foreign_data',
      FOREIGN_DATA_FILE = '/eurofxref-hist.zip';

$tempZipFile = getenv('temp').FOREIGN_DATA_FILE;
try {
  if (!copy (ECB_FOREX_URL, $tempZipFile)) throw new Exception ('HTTP read failed');
  $zipEngine = new ZipArchive();
  $zipEngine -> open($tempZipFile);
  $zipEngine -> extractTo(FOREIGN_DATA_FOLDER);
  $zipEngine -> close();
  unlink($tempZipFile);
}
catch (Throwable $err) {
  file_put_contents(__DIR__.'/ECB.errorlog.txt',
                    date('Y-m-d H:i:s - ').($err -> getMessage()).PHP_EOL, 
                    FILE_APPEND);
};
