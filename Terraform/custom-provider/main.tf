resource "fibb" "fibb_of_10" {
    n = 10
}

output "fibbResult" {
  value = fibb.fibb_of_10.result
}
