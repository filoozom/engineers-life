# Engineer's Life

CurseForge link: https://www.curseforge.com/minecraft/modpacks/engineers-life

## Volumes

- /minecraft/world

## Environment variables

- Change `MIN_RAM` (default `1024M`) to tune `-Xms`
- Change `MAX_RAM` (default `4096M`) to tune `-Xmx`
- Change `JAVA_PARAMETERS` to configure all other Java parameters (advanced)

# Security

This container runs Java as a non-privileged user, with `uid=567` and `gid=567`, meaning that local volumes need to set according permissions.

## Example command

```
# Create volumes and set permissions
mkdir world
chown -R 567:567 world

# Run the server
docker run -d \
	--name engineers-life \
	--restart always \
	-p 25565:25565 \
	-e MIN_RAM=512M \
	-e MAX_RAM=2048M \
	-v $(pwd)/world:/minecraft/world \
	filoozom/engineers-life
```

