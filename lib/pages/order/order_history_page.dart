import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todak_commerce/bloc/order/order_bloc.dart';
import 'package:todak_commerce/bloc/order/order_event.dart';
import 'package:todak_commerce/pages/order/order_detail_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  OrderHistoryPageState createState() => OrderHistoryPageState();
}

class OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    
    BlocProvider.of<OrderBloc>(context).add(LoadOrderHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          
          if (state is OrderInitial || state is OrderHistoryLoading) {
            
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderHistoryLoaded) {
            
            if (state.orders.isEmpty) {
              return const Center(
                child: Text('No past orders found.'),
              );
            }

            
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];                
                final formattedDate = DateFormat('d MMMM yyyy h:mm a').format(order.orderDate);
                return ListTile(
                  // title: Text('Order ID: ${order.id.substring(0, 8)}...'), 
                  subtitle: Text('Date: $formattedDate\nTotal: \$${order.totalAmount.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(order: order), 
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is OrderError) {
             
             return Center(
              child: Text('Error loading orders: ${state.message}'),
            );
          }
           
           return const Center(child: Text('Unknown order state.'));
        },
      ),
    );
  }
}
