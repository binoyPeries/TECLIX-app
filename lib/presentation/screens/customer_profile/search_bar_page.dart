import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teclix/data/models/Customer.dart';
import 'package:teclix/data/temporary/customer_search_results.dart';
import 'package:teclix/logic/bloc/search_customer/search_customer_bloc.dart';
import 'package:teclix/logic/bloc/search_customer/search_customer_event.dart';
import 'package:teclix/logic/bloc/search_customer/search_customer_state.dart';
import 'package:teclix/presentation/common/constants/TeclixColors.dart';
import 'package:teclix/presentation/common/widgets/appbar_back_btn.dart';
import 'package:teclix/presentation/common/widgets/common_padding.dart';
import 'package:teclix/presentation/screens/customer_profile/widgets/search_field.dart';
import 'package:teclix/presentation/screens/customer_profile/widgets/search_result_card.dart';
import 'package:teclix/presentation/screens/customer_profile/widgets/searchbar_preview.dart';

class SearchBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Customer> searchResults = [];

    final serachCustomerBloc = BlocProvider.of<SearchCustomerBloc>(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: Container(
            color: ColorPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                CommonPadding(
                  child: HeaderBackButton(
                    whenTapped: () => Navigator.pop(context),
                  ),
                ),
                Spacer(),
                CommonPadding(
                  child: BlocBuilder<SearchCustomerBloc, SearchCustomerState>(
                    builder: (context, state) {
                      return SearchField(
                        onSubmit: (String searchString) => {
                          serachCustomerBloc
                              .add(ToggleLoadingEvent(isLoading: true)),
                          new Timer(new Duration(seconds: 2), () {
                            searchResults = customerResults;
                            serachCustomerBloc
                                .add(ToggleLoadingEvent(isLoading: false));
                          }),
                        },
                      );
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        body: BlocBuilder<SearchCustomerBloc, SearchCustomerState>(
          builder: (context, state) {
            return state.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : searchResults.length == 0
                    ? SearchbarPreview()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: Text(
                              'Search Results',
                              style: TextStyle(
                                  color: ColorHeadingFont,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                            child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemCount: searchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SearchResultCard(
                                    shopName: searchResults[index].shopName,
                                    ownerLastName:
                                        searchResults[index].ownerLastName,
                                    ownerFistName:
                                        searchResults[index].ownerFistName,
                                    profilePicUrl:
                                        searchResults[index].profilePicUrl,
                                  );
                                }),
                          ),
                        ],
                      );
          },
        ),
      ),
    );
  }
}
