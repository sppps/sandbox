import binascii
from flask import Blueprint, jsonify
from backend.ipfs2pid import IPFS2PID, PID2IPFS


def create_blueprint():
    bp = Blueprint('api', __name__)

    @bp.route('ipfspid/<string:ipfs_hash>')
    def ipfspid(ipfs_hash):
        return jsonify({
            'pid': IPFS2PID(ipfs_hash)
            })

    @bp.route('pidipfs/<string:payment_id>')
    def pidipfs(payment_id):
        return jsonify({
            'ipfs': PID2IPFS(payment_id)
            })

    @bp.route('decode/<string:payment_id>')
    def decode(payment_id):
        x = payment_id
        if x[0] == '0' and x[1] == 'x':
            plain_hex = x.replace('0x', '')
            dec_hex = binascii.unhexlify(plain_hex)
        else:
            dec_hex = binascii.unhexlify(x)
        return jsonify({
            'msg': dec_hex.decode("utf-8")
            })

    @bp.route('encode/<string:msg>')
    def encode(msg):
        enc_hex = binascii.hexlify(bytearray(msg, 'latin-1')).zfill(64)
        return jsonify({
            'pid': enc_hex.decode("utf-8")
            })

    return bp
