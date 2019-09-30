#!/usr/bin/env python3

#import argparse
import configparser
import logging
import subprocess
import sys
import time

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

#parser = argparse.ArgumentParser()

config_path = 'config/monitor.ini'


if __name__ == '__main__':
    config = configparser.ConfigParser()
    config.read(config_path)
    # Timing
    idle_check_interval = int(config['general']['idle_check_interval'])
    idle_timeout_sec = int(config['general']['idle_timeout_sec'])
    idle_timeout = idle_timeout_sec * 1000
    # Scripts
    idle_time_path = config['scripts']['idle_time']
    start_cpu_miner_path = config['scripts']['start_cpu_miner']
    start_gpu_miner_path = config['scripts']['start_gpu_miner']
    start_both_miners_path = config['scripts']['start_both_miners']
    stop_both_miners_path = config['scripts']['stop_both_miners']

    idleState = False

    try:
        while True:
            idleTime = int(subprocess.run(['./getIdle'], capture_output=True).stdout.decode().rstrip('\n'))
            logger.debug('idleTime: ' + str(idleTime))

            if idleState is False:
                if idleTime > idle_timeout:
                    idleState = True

                    # START MINERS
                    logger.info('System entered idle state.')

                    start_miners = subprocess.run(['bash', start_both_miners_path], capture_output=True)
                    logger.debug(start_miners)
                
                time.sleep(idle_check_interval)

            else:
                if idleTime < idle_timeout:
                    idleState = False

                    # STOP MINERS
                    logger.info('System returned from idle state.')

                    stop_miners = subprocess.run(['bash', stop_both_miners_path], capture_output=True)
                    logger.debug(stop_miners)
                
                time.sleep(1)
            
            #time.sleep(idle_check_interval)
    
    except Exception as e:
        logger.exception(e)
    
    except KeyboardInterrupt:
        logger.info('Exit signal received.')
        sys.exit(0)