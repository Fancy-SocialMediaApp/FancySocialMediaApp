import 'package:flutter/material.dart';
import 'package:tugasbesar/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key, 
    required this.onProfileTap, 
    required this.onSignOut
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),

          const SizedBox(height: 50,),

          //home list tile 
          MyListTile(
            icon: Icons.home, 
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),

          //profile list tile
          MyListTile(
            icon: Icons.person, 
            text: 'P R O F I L E',
            onTap: (){},
          ),

          const SizedBox(height: 290,),

          //logout list tile
          MyListTile(
            icon: Icons.logout, 
            text: 'L O G O U T',
            onTap: (){},
          ),
        ],
      ),
    );
  }
}