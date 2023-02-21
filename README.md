# Frigate NVR installation on Jetson Nano 4GB

1. Download all files to  `/home/nano/frigate` and navigate to the folder.

2. The Jetson Nano 4GB doesn't come preinstalled with docker compose. Installing docker compose on the Jetson Nano can be annoying, I've compiled a script to speed things up:  `prepnano.sh` (you might need to replace the download link in the `prepnano.sh` file with the newest `docker-compose-linux-aarch64` link): 

    https://github.com/docker/compose/releases

    Give execute permissions and launch:
    ```bash
    sudo chmod +x prepnano.sh && sh prepnano.sh
    ```

    `prepnano.sh` should install Curl, Nano and Docker Compose (which were not provided with the Jetson SDK I am running)

3. Adjust volumes in the `frigate.yml` file for your setup:
    ```bash       
    - /home/nano/frigate/config.yml:/config/config.yml:ro
    - /PATH/TO/YOUR_FOLDER:/media/frigate
    ```

4. Update the following in `config.yml`:
    *  MQTT `username`, `password`, `IP` and `port`. (this assumes you have an MQTT server running. I recommend [Mosquitto](https://mosquitto.org/))
    * Storage preferences (under `record`)
    * Detector preferences (under `detectors`)
    * Camera `username`, `password`, `IP` and `port`
    * Camera size (`detect` `width` and `height`)
    * Items to track (`person`, `dog`, etc.)


5. Append this to the root crontab:
    ```bash
    @reboot docker compose -f /home/nano/frigate/frigate.yml up -d
    ```
6. Reboot Jetson Nano
    ```bash
    sudo reboot
    ```

7. Test that Frigate is running with `sudo docker ps`. You should get output like: 

```bash
CONTAINER ID   IMAGE                                    COMMAND                  CREATED             STATUS         PORTS                                                                                  NAMES
1234567891   blakeblackshear/frigate:stable-aarch64   "/init python3 -u -m…"   About an hour ago   Up 3 minutes   0.0.0.0:1935->1935/tcp, :::1935->1935/tcp, 0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   frigate
```

8. Navigate to Frigate in browser: `http://replace_this_with_frigate_ip:5000/`