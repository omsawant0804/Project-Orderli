import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orderligui/Customer/CustBootomNav.dart';
import 'package:orderligui/Restaurant/PaymentGateway.dart';
import '../OtherFiles/Animation.dart';
import 'package:iconsax/iconsax.dart';

class CustomerMenuPage extends StatefulWidget {
  String restoId="";
  CustomerMenuPage(String restoId){
    this.restoId=restoId;
  }
  @override
  _CustomerMenuPageState createState() => _CustomerMenuPageState(restoId);
}

class _CustomerMenuPageState extends State<CustomerMenuPage> {
  String restoId="";
  _CustomerMenuPageState(String restoId){
    this.restoId=restoId;
    print(restoId);
  }
  Map<String, int> _selectedItems = {};
  Map<String, double> _itemPrices = {};

  @override
  void initState() {
    super.initState();
    _fetchItemPrices();
  }

  void _fetchItemPrices() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Restaurant')
        .doc(restoId) // Replace with actual restaurant ID
        .collection('Menu')
        .get();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      _itemPrices[data['itemName']] = data['price'].toDouble();
    });

    setState(() {});
  }

  void callBackendPay(double totalAmount){
    Razc razc = Razc(context);
    razc.openCheckout(totalAmount);
  }


  void _placeOrder(BuildContext context,String Phno, String userId, String userName, String restoId, String restoName, int selectedTable, String additionalNote, double totalAmount) async {
    CollectionReference ordersCollection = FirebaseFirestore.instance
        .collection('orders'); // Separate collection for orders
    print(_itemPrices);
    print(_selectedItems);
    Map<String, dynamic> orderData = {
      'userId': userId, // Add user ID
      'userName': userName, // Add user name
      'restoId': restoId, // Add restaurant ID
      'restoName': restoName, // Add restaurant name
      'selectedTable': selectedTable,
      'additionalNote': additionalNote,
      'totalAmount': totalAmount,
      'userPhonenumber':Phno,
      'status':"Pending..",
      'items': _selectedItems.map((key, value) {
        return MapEntry(key, {
          'count': value,
          'price': _itemPrices[key],
        });
      }),
      'timestamp': Timestamp.now(),
    };

    await ordersCollection.add(orderData);

    setState(() {
      _selectedItems.clear();
      selectedTable = 1;
      additionalNote = '';
    });

    // Navigator.pop(context); // Close the bottom sheet
    print("hello");
    // Create an instance of Razc and call openCheckout
    // Razc razc = Razc(context);
    // razc.openCheckout(totalAmount);





  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle case where user is not signed in
      return '';
    }
  }

  Future<String> getCurrentUserName() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot['Name'] ?? ''; // Assuming the user's name field is named 'name' in Firestore
      }
    }
    return ''; // Return empty string if user ID is not available or user document does not exist
  }

  Future<String> getCurrentUserPhno() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot['phnoNumber'] ?? ''; // Assuming the user's name field is named 'name' in Firestore
      }
    }
    return ''; // Return empty string if user ID is not available or user document does not exist
  }

  Future<String> getRestoName(String restoId) async {
    DocumentSnapshot restoSnapshot = await FirebaseFirestore.instance.collection('Restaurant').doc(restoId).get();
    if (restoSnapshot.exists) {
      return restoSnapshot['Name'] ?? ''; // Assuming the restaurant name field is named 'name' in Firestore
    }
    return ''; // Return empty string if restaurant document does not exist or name field is not available
  }

  GetPlaceOrderData(BuildContext context,int selectedTable, String additionalNote, double totalAmount)async{
    String userId=getCurrentUserId();
    String userName=await getCurrentUserName();
    String restoName= await getRestoName(restoId);
    String Phno=await getCurrentUserPhno();
    _placeOrder(context,Phno, userId, userName, restoId, restoName, selectedTable, additionalNote, totalAmount);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(left: 0), // Adjust the left padding as needed
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF040404),
                fontSize: 20,
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
            child: IconButton(
              color: Color(0xFF040404),
              iconSize: 25,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(Right_Animation(child: CustVav(),
                    direction: AxisDirection.right));

              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          backgroundColor: Colors.white, // Your original background color
        ),
      ),
      body: _itemPrices.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Restaurant')
            .doc(restoId) // Replace with actual restaurant ID
            .collection('Menu')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
                return _buildMenuItemCard(document.reference, data);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTotalDialog(context);
        },
        child: Icon(Icons.shopping_cart, color: Colors.white),
        backgroundColor: Color(0xFFEF6129),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMenuItemCard(
      DocumentReference documentRef, Map<String, dynamic> data) {
    MenuItem menuItem = MenuItem.fromData(data);

    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(
              menuItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.itemName,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 250,
                      child: Text(
                        menuItem.description,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: ₹${menuItem.price.toStringAsFixed(2)}',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      _decrementItem(menuItem);
                    },
                  ),
                  Text('${_selectedItems[menuItem.itemName] ?? 0}'),
                  IconButton(
                    icon: Icon(Iconsax.add),
                    onPressed: () {
                      _incrementItem(menuItem);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _incrementItem(MenuItem item) {
    setState(() {
      if (_selectedItems.containsKey(item.itemName)) {
        _selectedItems[item.itemName] = _selectedItems[item.itemName]! + 1;
      } else {
        _selectedItems[item.itemName] = 1;
      }
    });
  }

  void _decrementItem(MenuItem item) {
    setState(() {
      if (_selectedItems.containsKey(item.itemName)) {
        if (_selectedItems[item.itemName]! > 0) {
          _selectedItems[item.itemName] = _selectedItems[item.itemName]! - 1;
        }
      }
    });
  }

  double _calculateTotal() {
    double total = 0.0;
    _selectedItems.forEach((itemName, count) {
      total += _itemPrices[itemName]! * count;
    });
    return total;
  }

  void _showTotalDialog(BuildContext context) {
    double totalPrice = _calculateTotal();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ₹${totalPrice.toStringAsFixed(2)}',
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showOrderSummaryBottomSheet(context, totalPrice);
                },
                child: Text('Next >>'),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showOrderSummaryBottomSheet(BuildContext context, double totalPrice) {
  //   double totalAmount = totalPrice;
  //   int selectedTable = 1;
  //   String additionalNote = '';
  //
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return SingleChildScrollView(
  //             child: Container(
  //               padding: EdgeInsets.all(20.0),
  //               height: MediaQuery.of(context).size.height * 0.8, // Set a fixed height
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Order Summary',
  //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(height: 20),
  //                   Expanded(
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                         children: _selectedItems.entries.map((entry) {
  //                           String itemName = entry.key;
  //                           int count = entry.value;
  //                           double price = _itemPrices[itemName]!;
  //                           double itemTotal = count * price;
  //
  //                           return Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text('$itemName x $count'),
  //                               Text('Price: ₹$price'),
  //                               Text('Total: ₹${itemTotal.toStringAsFixed(2)}'),
  //                               SizedBox(height: 10),
  //                             ],
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ),
  //                   ),
  //                   Divider(),
  //                   Text(
  //                     'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
  //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(height: 20),
  //                   Text(
  //                     'Select Table',
  //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(height: 10),
  //                   DropdownButton<int>(
  //                     value: selectedTable,
  //                     onChanged: (newValue) {
  //                       setState(() {
  //                         selectedTable = newValue!;
  //                       });
  //                     },
  //                     items: List.generate(
  //                       10,
  //                           (index) => DropdownMenuItem<int>(
  //                         value: index + 1,
  //                         child: Text('Table ${index + 1}'),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   TextField(
  //                     onChanged: (value) {
  //                       additionalNote = value;
  //                     },
  //                     decoration: InputDecoration(
  //                       hintText: 'Additional Note (Optional)',
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   Center(
  //                     child:             Row(
  //                       mainAxisSize: MainAxisSize.max,
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Material(
  //                           color: Colors.transparent,
  //                           // elevation: 2,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(0),
  //                           ),
  //                           child: Container(
  //                             width: 335,
  //                             height: 52,
  //                             decoration: BoxDecoration(
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   blurRadius: 4,
  //                                   color: Color(0x33000000),
  //                                   offset: Offset(0, 2),
  //                                 )
  //                               ],
  //                               gradient: LinearGradient(
  //                                 colors: [Color(0xFFE86A42), Color(0xFFE86A42)],
  //                                 stops: [0, 1],
  //                                 begin: AlignmentDirectional(-1, 0.64),
  //                                 end: AlignmentDirectional(1, -0.64),
  //                               ),
  //                               borderRadius: BorderRadius.circular(18),
  //                             ),
  //                             child: Padding(
  //                               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
  //                               child: InkWell(
  //                                 splashColor: Colors.transparent,
  //                                 focusColor: Colors.transparent,
  //                                 hoverColor: Colors.transparent,
  //                                 highlightColor: Colors.transparent,
  //                                 child: TextButton(
  //                                   child: Text('Place Order',
  //                                     textAlign: TextAlign.center,
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                   onPressed: ()async{
  //                                     GetPlaceOrderData(context, selectedTable, additionalNote, totalAmount);
  //                                     callBackendPay(totalAmount);
  //                                     Navigator.pop(context);
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showOrderSummaryBottomSheet(BuildContext context, double totalPrice) {
    double totalAmount = totalPrice;
    int selectedTable = 1;
    String additionalNote = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be scrollable
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                ),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.8, // Set a fixed height
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _selectedItems.entries.map((entry) {
                              String itemName = entry.key;
                              int count = entry.value;
                              double price = _itemPrices[itemName]!;
                              double itemTotal = count * price;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$itemName x $count'),
                                  Text('Price: ₹$price'),
                                  Text('Total: ₹${itemTotal.toStringAsFixed(2)}'),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Divider(),
                      Text(
                        'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Select Table',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<int>(
                        value: selectedTable,
                        onChanged: (newValue) {
                          setState(() {
                            selectedTable = newValue!;
                          });
                        },
                        items: List.generate(
                          10,
                              (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('Table ${index + 1}'),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          additionalNote = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Additional Note (Optional)',
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Container(
                                width: 335,
                                height: 52,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFE86A42), Color(0xFFE86A42)],
                                    stops: [0, 1],
                                    begin: AlignmentDirectional(-1, 0.64),
                                    end: AlignmentDirectional(1, -0.64),
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: TextButton(
                                      child: Text(
                                        'Place Order',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        GetPlaceOrderData(context, selectedTable, additionalNote, totalAmount);
                                        callBackendPay(totalAmount);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class MenuItem {
  final String itemName;
  final String description;
  final double price;
  final String imageUrl;

  MenuItem({
    required this.itemName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory MenuItem.fromData(Map<String, dynamic> data) {
    return MenuItem(
      itemName: data['itemName'],
      description: data['description'],
      price: data['price'].toDouble(),
      imageUrl: data['imageUrl'],
    );
  }
}