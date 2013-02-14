class redelinux::ssh
{
	package { 'openssh-server':
		ensure => present,
	}
	
	Ssh_authorized_key {
		user    => 'root',
		type    => 'ssh-rsa',
		require => Package['openssh-server'],
	}
	
	ssh_authorized_key { 'kayle':
		ensure => present,
		key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDC+R7JfxrAc29y7Z+c/+KKSB7KbgWJLfaCFvYzbHjd9IgfpqzHOPhZX6x+Fwx5eETs3Cu8UMmjModCtOP/FBaKO2AnhjudKV+sIumyyMRoeaBd7RxCYmcw4mFG5TKHMONjwrXqbK1Vc8PFZJnxquBzqwxJ+2M4+kWPvaIf3be1Z4iLTaEvKWsyByuGq0O+0hHFq2tSFoQTCtKWoHpqsem+cJbqUymkqEOwarmR362Di6pL+V0RI26RIPp9knn9cG8d8i9Qd86RDic9750u1LUQuMFI4FeRayA6ej4rXN1t76kewcsqg8sCzvNtLXZuOUMR1ELMh7pYpwn5OR8OYZd3',
	}
	
	ssh_authorized_key { 'gnann':
		ensure => present,
		key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC3I+Mk603WOSQx87nWYaHDVe43fAK3HJEEiugZ/ORlO65Lo8WRdE6QT85278a5o5ZEIasEQKX6nuRlYmEgOmDW71o1VIyf4pz9iGHV9UL2r6hE6EFNnQ4/1DMWV3XWLyW1SR6MUQrTeZQfVZD7TFdCOc1XX/wcXg2xFelLXbb8FUneg+VZ8b34rbxBUkkHngWsUWKn4unXwPiCo5KdVm515RoVoU1X9homuprAdPR1I0Ub1I9GyiX2RtW2JaMPhcxXyoUekin+c6kCeiPrvuTxQmONfkiPviBUmpTsPw4ZZDDLTm3hxBXztLdLTemXhyDAKVbKXw6hdSp0tQpEcoRF',
	}
}
