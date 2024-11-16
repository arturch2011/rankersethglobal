import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/user_provider.dart';

class BuildProfileAvatar extends StatelessWidget {
  final double size;
  const BuildProfileAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);
    String? urlImagem;
    String name = "User";
    try {
      urlImagem = auth.userInfos!['userInfo']["profileImage"];
      name = auth.userInfos!['userInfo']["name"];
    } catch (e) {
      urlImagem = null;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Cor da borda
          width: 2, // Largura da borda
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: size,
        backgroundImage: urlImagem != null ? NetworkImage(urlImagem) : null,
        backgroundColor: Colors.grey[300],
        child:
            urlImagem == null ? Text(name.substring(0, 1).toUpperCase()) : null,
      ),
    );
  }
}
