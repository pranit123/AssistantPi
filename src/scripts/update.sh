#!/bin/bash
echo ""
echo "Starting AssistantPi Quick Update..."
echo "#############################################"
echo "This will wipe all changes you may have done to /opt/AlexaPi."
read -r -p "Backup your config.template.yaml and assistant.example.asoundrc ? [y/N]: " bkp

case $bkp in
    [Yy] )
		echo ""
		echo "## Backup config files"
		cd /opt
		sudo mkdir AlexaPi-bkp
		sudo mkdir AlexaPi-bkp/src
		sudo cp /opt/AlexaPi/src/assistant.example.asoundrc /opt/AlexaPi-bkp/src/assistant.example.asoundrc
		sudo cp /opt/AlexaPi/src/config.template.yaml /opt/AlexaPi-bkp/src/config.template.yaml
	;;
    *)
    ;;
esac

echo ""
echo "## Update AssistantPi Core"
cd /opt/AlexaPi
sudo git checkout -- .
sudo git checkout master
sudo git pull

echo ""
echo "## Update tweaked Google Assistant SDK"
cd /opt/AlexaPi/src/assistant-sdk-python
sudo git checkout -- .
sudo git checkout master
sudo git pull
sudo /opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"


case $bkp in
    [Yy] )
		echo ""
		echo "## Reinstall backed up files"
		sudo mv /opt/AlexaPi-bkp/src/assistant.example.asoundrc /opt/AlexaPi/src/assistant.example.asoundrc
		sudo mv /opt/AlexaPi-bkp/src/config.template.yaml /opt/AlexaPi/src/config.template.yaml
		sudo rm -rf /opt/AlexaPi-bkp
	;;
    *)
    ;;
esac


echo ""
echo "Finished Quick Update."
echo ""
