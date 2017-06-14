import os
import sys
import requests
import json
from time import sleep

# testnet
url = "http://localhost:18082/json_rpc"
node = "http://localhost:28081/json_rpc"
headers = {'content-type': 'application/json'}

def clear_screen():
    if sys.platform == 'win32' or sys.platform == 'win':
        os.system('cls')
    elif sys.platform == 'linux' or sys.platform == 'linux2':
        os.system('clear')

def bye():
    print'''
    Thanks for using the app.
    '''
    sys.exit()

def get_txs():
    rpc_input = {
            "method": "incoming_transfers",
            "params": {"transfer_type": "all"}
    }
    rpc_input.update({"jsonrpc": "2.0", "id": "0"})

    # execute the rpc request
    response = requests.post(
         url,
         data=json.dumps(rpc_input),
         headers=headers)

    # make json dict with response
    response_json = response.json()

    if "result" in response_json:
        if "transfers" in response_json["result"]:
            for transfer in response_json["result"]["transfers"]:
                transfer["amount"] = float(get_money(str(transfer["amount"])))

    # pretty print json output
    print'\nIncoming Transfers : '
    print(json.dumps(response_json, indent=4))

def get_balance():
    rpc_input = {
           "method": "getbalance"
    }
    rpc_input.update({"jsonrpc": "2.0", "id": "0"})
    response = requests.post(
        url,
        data=json.dumps(rpc_input),
        headers=headers)
    # print(json.dumps(response.json(), indent=4))
    print'\nBalance : '
    print(response.json()["result"])

def get_address():
    rpc_input = {
           "method": "getaddress"
    }
    rpc_input.update({"jsonrpc": "2.0", "id": "0"})
    response = requests.post(
        url,
        data=json.dumps(rpc_input),
        headers=headers)
    # print(json.dumps(response.json(), indent=4))
    print'\nWallet Address : '
    print(response.json()["result"])

def make_integrated_address():
    rpc_input = {
           "method": "make_integrated_address",
           "params": {"payment_id": ""}
    }
    rpc_input.update({"jsonrpc": "2.0", "id": "0"})
    response = requests.post(
        url,
        data=json.dumps(rpc_input),
        headers=headers)
    # print(json.dumps(response.json(), indent=4))
    print'\nIntegrated Address : '
    print(response.json()["result"])

def network_info():
    rpc_input = {
           "method": "get_info"
    }
    rpc_input.update({"jsonrpc": "2.0", "id": "0"})
    response = requests.post(
        node,
        data=json.dumps(rpc_input),
        headers=headers)
    print(json.dumps(response.json(), indent=4))

def get_money(amount):
    #decode cryptonote amount format to user friendly format. Hope its correct

    CRYPTONOTE_DISPLAY_DECIMAL_POINT = 12

    s = amount

    if len(s) < CRYPTONOTE_DISPLAY_DECIMAL_POINT + 1:
        # add some trailing zeros, if needed, to have constant width
        s = '0' * (CRYPTONOTE_DISPLAY_DECIMAL_POINT + 1 - len(s)) + s

    idx = len(s) - CRYPTONOTE_DISPLAY_DECIMAL_POINT

    s = s[0:idx] + "." + s[idx:]

    return s

def choice():
    print'+' + '='*78 + '+'
    print"\t  1. Incoming Transfers"
    print"\t  2. Check My Balance"
    print"\t  3. My Wallet Address"
    print"\t  4. Create Integrated Address" 
    print"\t  5. Network Information"    
    print"\t  0. Exit"
    print'+' + '='*78 + '+'

    usr_input = input('\n Enter number : ')
    if usr_input == 1:
       clear_screen()
       get_txs()
       choice()
    elif usr_input == 2:
       clear_screen()
       get_balance()
       choice()
    elif usr_input == 3:
       clear_screen()
       get_address()
       choice()
    elif usr_input == 4:
       clear_screen()
       make_integrated_address()
       choice()
    elif usr_input == 5:
       clear_screen()
       network_info()
       choice()
    elif usr_input == 0:
         bye()
    else:
        print'\n\033[1;31mInvalid\033[0m : Please try again.'
        sleep(2)
        choice()

def main():
    choice()

main()
