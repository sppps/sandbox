import os
import sys
from time import sleep

def clear_screen():
    if sys.platform == 'win32' or sys.platform == 'win':
        os.system('cls')
    elif sys.platform == 'linux' or sys.platform == 'linux2':
        os.system('clear')

def banner():
    print'''
    +=======================================================================+

    Monero Payment ID Message Encoder/Decoder

    Warning: The Payment ID field is not encrypted and anyone can see your 
    message on the blockchain. There is a risk of deanonymization if not 
    used carefully.


    +=======================================================================+

    '''

def bye():
    print'''
    Thanks for using the app.
    '''
    sys.exit()

def hex_convert(x,y):
    if y == 'e':
        enc_hex = x.encode('hex').zfill(64)
        print''
        print'+' + '='*78 + '+'
        print'Payment Id : ', enc_hex
        print'Characters :', len(enc_hex), '\033[32mGood\033[0m'
        print'+' + '='*78 + '+'
        bye()
    elif y == 'd':
        if x[0] == '0' and x[1] == 'x':
            plain_hex = x.replace('0x','')
            dec_hex = plain_hex.decode('hex')
        else:
            dec_hex = x.decode('hex')
        print''
        print'+' + '='*78 + '+'
        print'Message : ', dec_hex
        print'+' + '='*78 + '+'
        print'\n\n\n'
        bye()

def choice():
    print('\n')
    print"\t  1. Encode Message to Payment ID"
    print"\t  2. Decode Message from Payment ID"
    print"\t  3. Encode IPFS hash to Payment ID"
    print"\t  4. Decode IPFS hash from Payment ID"
    print"\t  0. Exit"

    usr_input = input('\n Enter number : ')
    if usr_input == 1:
       clear_screen()
       print'\nEnter message (maximum 32 charaters) '
       string = raw_input(" >> ")
       if len(string) >= 33:
          print'\n\033[1;31mError\033[0m : You are over', len(string)-32, 'characters. Please try again.'
          sleep(2)
          choice()
       else:
         hex_convert(string,'e')
    elif usr_input == 2:
         clear_screen()
         print'\nEnter Payment ID '
         hex = raw_input(" >> ")
         hex_convert(hex,'d')
    elif usr_input == 0:
         bye()
    elif usr_input == 3:
         clear_screen()
         bye()
    elif usr_input == 4:
         clear_screen()
         bye()
    else:
        print'\n\033[1;31mInvalid\033[0m : Please try again.'
        sleep(2)
        choice()

def main():
    banner()
    choice()

main()


