#!/bin/bash

count=1

while [ $count -le 70 ]; do
  # Виконати Dart-файл
  dart tester-rpc.dart

  # Затримка на 5 секунд
  sleep 5

  ((count++))
done
