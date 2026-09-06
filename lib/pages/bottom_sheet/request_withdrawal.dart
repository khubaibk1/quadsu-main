import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quadsu_app/constants/api_keys.dart';
import 'package:quadsu_app/constants/global_data.dart';
import 'package:quadsu_app/constants/my_colors.dart';
import 'package:quadsu_app/constants/sized_box.dart';
import 'package:quadsu_app/provider/withdraw_provider.dart';
import 'package:quadsu_app/widget/custom_text.dart';
import 'package:quadsu_app/widget/show_snackbar.dart';

import '../../functions/validation_functions.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_text_field.dart';

class RequestWithdrawal extends StatelessWidget {
  RequestWithdrawal({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController amountController = TextEditingController(
      text: '$cur${userDataNotifier.value?.walletAmount}');
  final ValueNotifier aboutUsNotifier = ValueNotifier({'key': "Paypal"});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomText.headingSmall(
            'Request Withdrawal',
            fontWeight: FontWeight.w600,
          ),
          vSizedBox3,
          CustomTextField(
            controller: amountController,
            obscureText: false,
            hintText: "0",
            fillColor: MyColors.whiteColor,
            borderColor: MyColors.whiteColor,
            headingText: 'Wallet Amount',
            headingFontSize: 16,
            hintTextFontSize: 22,
            readOnly: true,
            focusedBorderColor: MyColors.whiteColor,
            fontSize: 22,
            contentPaddingVertical: 11,
            fontWeight: FontWeight.w600,
            prefix: Padding(
              padding: const EdgeInsets.only(left: 05),
              child: CustomText.textFieldHint(
                '',
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            headingFontWeight: FontWeight.w600,
            validator: (val) {
              return ValidationFunction.requiredValidation(val);
            },
            keyboardType: TextInputType.number,
          ),
          vSizedBox,
          ValueListenableBuilder(
            valueListenable: aboutUsNotifier,
            builder: (context, aboutUsNotifierValue, child) =>
                CustomDropdownButton(
              items: const [
                {'key': 'Paypal'},
                {'key': 'Venmo'},
              ],
              hint: 'Select',
              headingText: 'Withdrawal using :',
              onChangedSingle: (v) {
                print("dtadtdatdta:::::$v");
                aboutUsNotifier.value = v;
              },
              itemMapKey: "key",
              singleSelectedItem: aboutUsNotifierValue,
              headingFontSize: 15,
              validatorSingle: (val) {
                return ValidationFunction.requiredValidation(val);
              },
            ),
          ),
          vSizedBox2,
          ValueListenableBuilder(
              valueListenable: aboutUsNotifier,
              builder: (context, aboutUsNotifierValue, child) {
                return CustomTextField(
                  controller: emailAddress,
                  hintText: aboutUsNotifierValue['key'] == "Paypal"
                      ? "Paypal Email"
                      : "Venmo Username",
                  headingText: aboutUsNotifierValue['key'] == "Paypal"
                      ? "Paypal Email"
                      : "Venmo Username",
                  headingFontSize: 15,
                  hintTextFontSize: 15,
                  fontSize: 15,
                  validator: (val) {
                    if (aboutUsNotifierValue['key'] == "Paypal") {
                      return ValidationFunction.emailValidation(val);
                    } else {
                      return ValidationFunction.requiredValidation(val);
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                );
              }),
          vSizedBox,
          CustomButton(
            height: 50,
            borderRadius: 4,
            text: 'Request',
            fontWeight: FontWeight.w600,
            onTap: () {
              if (userDataNotifier.value!.walletAmount.isNotEmpty &&
                  userDataNotifier.value?.walletAmount != "0" &&
                  userDataNotifier.value?.walletAmount != "0.0") {
                if (aboutUsNotifier.value == null) {
                  showSnackbar("Please select withdrawal method");
                  return;
                }

                if (formKey.currentState!.validate()) {
                  Map<String, dynamic> request = {
                    ApiKeys.widthdrawalUsing: aboutUsNotifier.value['key']
                  };

                  if (aboutUsNotifier.value['key'] == "Paypal") {
                    request[ApiKeys.paypalEmail] = emailAddress.text.trim();
                  } else {
                    request[ApiKeys.venmoUsername] = emailAddress.text.trim();
                  }
                  WithdrawProvider withdrawProvider =
                      Provider.of<WithdrawProvider>(context, listen: false);
                  withdrawProvider.requestWithdraw(request: request);
                }
              } else {
                showSnackbar("You don't have enough wallet amount to withdraw.");
                return;
              }
            },
          )
        ],
      ),
    );
  }
}
