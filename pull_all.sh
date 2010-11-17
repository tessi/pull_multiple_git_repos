#!/usr/bin/expect -f
set prompt "((%|#|\\$| :) |>|])$"
 if [info exists env(EXPECT_PROMPT)] {
    set prompt $env(EXPECT_PROMPT)
      }
set timeout -1
set scriptHome [exec pwd]

send_user "password: "
stty -echo
expect_user -re "(.*)\n" {set pw $expect_out(1,string)}
send_user "\n"
stty echo

# Now look for any sub direcories in the current directory
foreach dirName [glob -nocomplain -types {d r} -directory $scriptHome *] {
  puts "\nUpdating $dirName"
  cd $dirName
  spawn -noecho git pull -p
  log_user 0
  expect -re "Password: " { send "$pw\n" }
  expect -re "(.*)$prompt"
  log_user 1
  puts $expect_out(buffer)
  cd $scriptHome
}

