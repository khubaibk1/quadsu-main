


class TwilioModal{


   var account_sid;
   var body;
   var date_created;
   var date_sent;
   var date_updated;
   var direction;
   var error_code;
   var error_message;
   var from;
   var to;
   Map? full_data;

   TwilioModal({
     this.account_sid,
      this.body,
      this.date_created,
      this.date_sent,
      this.date_updated,
      this.direction,
      this.error_code,
      this.error_message,
      this.from,
      this.to,
      this.full_data,
   });

   factory TwilioModal.fromJson(Map json){
     return TwilioModal(
         account_sid:json['account_sid'],
         body:json['body'],
         date_created:json['date_created'],
         date_sent:json['date_sent'],
         date_updated:json['date_updated'],
         direction:json['direction'],
         error_code:json['error_code'],
         error_message:json['error_message'],
         from:json['from'],
         to:json['to'],
       full_data:json,
     );
   }
}
