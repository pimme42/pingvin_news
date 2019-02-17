class NotificationDecoder {
/* *** onMessage ***
{
  notification:
    {
      title: Ny tränare8,
      body: Pingvin har anställt en ny tränare
    },
  data:
    {
      id: 123,
      nid: 456,
      click_action: FLUTTER_NOTIFICATION_CLICK
    }
}
*/
  static Map<String, dynamic> decodeOnMessage(Map<String, dynamic> message) {
    Map<String, dynamic> json = {
      'id': int.parse(message['data']['id']),
      'nid': int.parse(message['data']['nid']),
    };
    return json;
  }

/* *** onResume ***
{
  collapse_key: se.rorstam.pingvinnews,
  google.original_priority: high,
  google.sent_time: 1549188408658,
  google.delivered_priority: high,
  nid: 456,
  google.ttl: 600,
  from: 154008194571,
  id: 123,
  click_action: FLUTTER_NOTIFICATION_CLICK,
  google.message_id: 0:1549188408781817%45b37fd445b37fd4
}
*/
  static Map<String, dynamic> decodeOnResume(Map<String, dynamic> message) {
    Map<String, dynamic> json = {
      'id': int.parse(message['id']),
      'nid': int.parse(message['nid']),
    };
    return json;
  }
}
