import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseView {
  Widget displayLoadingScreen(BuildContext context,
      {Color color = Colors.white}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget displayErrorMessage(
      BuildContext context, Function onRefresh, String errorMessage,
      {Color textColor = Colors.black}) {
    if (errorMessage == "" || errorMessage == null) {
      errorMessage = "Data tidak ditemukan";
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [],
          ),
          Center(
            child: Container(
              child: Text(
                errorMessage,
                style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
