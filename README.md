# Payment Offline Backend

## API Docs

### GET /status

returns `{"status":"running"}` with code 200 if it runs correctly.

### POST /charge

request body

```json
{
  money: Integer,
  channel: String
}
```

Money should be multiplied by 100. For example, if you wanna charge ￥0.01, the money parameter should be 1.

Channel is a enum, which was listed below.

```
alipay: Alipay mobile
bfb: Baidu pay mobile
wx: Wechat Pay
cnp_u:Pay Inside the app pay(UnionPay)
applepay_upacp:Apple Pay
```

It returns a JSON object for Ping++ SDK, one thing you have to parsr it is that the order_id, which would later be used in testing the charge status

### WebSocket /waiting/:order_id

The websocket would returns `{"status":"charged"}` if charge successfully.