---
title: Easy WSL Upgrades
date: 2024-11-17
---

I've been using WSL to make developing on windows a bit more comfortable. One thing I've been trying to get a handle on is how to manage WSL major version upgrades. I've done it a different way each time I've needed a major upgrade, but I think I'm finally happy with the following, but it requires a bit of prep:

* Create a virtual disk drive, formatted to a linux compatible filesystem
* Attach the virtual drive to WSL on login
* Update /etc/fstab to mount the drive to home directory
* Use WSL like you normally would
* When it is time to make a major upgrade, delete the old VM, and install the new VM
* Update /etc/fstab of the new VM to mount the drive to home directory

For small updates, using the distro's package manager is fine, but this setup preserves the home directory, so it is safe to delete the VM without losing data.

Here are the steps: 

# create the virtual drive

To create a dynamically sized (only used space takes space) virtual drive with max 100GB of storage:

```powershell
New-VHD -Path C:\Users\user\wslhome.vhdx -Dynamic -SizeBytes 100GB
```

## attach the drive to WSL VM(s)

This command will attach the virtual drive to ALL WSL machines as a block device (e.g. /dev/sdX), so at this point, we can create the filesystem on it within a WSL VM:

After creating the drive, we need to attach it to WSL. The `--bare` option prevents WSL from actually mounting the drive, despite using the `--mount`.

```powershell
wsl.exe --mount --bare --vhd C:\Users\user\wslhome.vhdx
```

## Find the drive device in WSL

We need to figure out the name of our virtual drive device after it is attached:

```bash
$ lsblk # find your drive device based on size
sda      8:0    0 388.4M  1 disk
sdb      8:16   0     2G  0 disk [SWAP]
sdc      8:32   0   100G  0 disk
sdd      8:48   0     1T  0 disk /mnt/wslg/distro
```

We see that our 100GB device is named 'sdc', so we can reference it as `/dev/sdc` in following commands.


## Partition the drive

The following will create a single whole disk parition.

```bash
$ sudo parted -s --align optimal -- /dev/sdc mklabel gpt mkpart primary ext4 0% 100%
```

## Format and label the drive

We've got a partition, but we can't store anything there until we set up a file system:

```bash
$ sudo mkfs -t ext4 /dev/sdc1
$ sudo e2label /dev/sde1 wslhome # add a label to make automounting a bit easier
```

## Mount the drive and copy your home directory over

Because this drive will serve as my user directory in WSL, I figured I'd copy over my existing stuff. So I mounted the drive somewhere to copy files over to:

```bash
$ sudo mkdir -p /mnt/wslhome
$ sudo mount -t ext4 --label wslhome /mnt/wslhome
$ sudo mkdir /mnt/wslhome/user
$ sudo chown user: /mnt/wslhome/user
$ (cd $HOME; tar cvf - .) | (cd /mnt/wslhome/user; tar xvf -) # copy the entire home dir to new volume
$ sudo umount /mnt/wslhome && sudo rmdir /mnt/wslhome
```

After running all of that, we've populated the virtual drive with our current home dir data.

## Set up WSL VM to mount the virtual drive

The following command adds an entry to fstab that will mount our volume named 'wslhome' to /home. 

```bash
#in WSL VM
$ echo 'LABEL=wslhome /home ext4 defaults 0 2' | sudo tee -a /etc/fstab 1>/dev/null
```

## Auto-attach volume to WSL on login

Unfortunately, there doesn't seem to be a way to set WSL to automatically attach our volume, but we need it to be attached when the VM boots, and we don't want to run that command every time.

Fortunately, windows supports scheduled tasks on login, so we use that.

Create the scheduled task to automount the WSL volume:

* Windows+R
* type 'taskschd.msc', hit Enter
* In right pane, click 'Create Basic Task'
* Enter a name for the task in the 'Name' field, click 'Next'
* Choose 'When I log on", click 'Next' 
* Make sure 'Start a program' is selected and hit 'Next'
* In 'Program/script', enter "C:\Windows\System32\wsl.exe" 
* In 'Add arguments', enter "--mount --bare --vhd C:\Users\user\wslhome.vhdx", click 'Next'
* Click 'Finish'

Now, logging in should attach our disk to WSL, automatically.

## Test it!

At this point we should be able to start up our WSL VM and see our home directory mounted on our virtual disk:

```bash
$ mount | grep /home
/dev/sdc1 on /home type ext4 (rw,relatime)
```

