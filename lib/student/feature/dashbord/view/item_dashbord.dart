
import 'package:flutter/material.dart';
import 'package:smart_academy/student/feature/dashbord/model/model_dashboard.dart';

class ItemDashboard extends  StatelessWidget{
 final ModelDashboard modelDashboard ;
  const ItemDashboard({super.key ,required this.modelDashboard});

  @override
  Widget build(BuildContext context) {
    final displaySmall =Theme.of(context).textTheme.displaySmall;

    SizedBox(height: MediaQuery.of(context).size.height * 0.2,);
    return Container(
      margin: EdgeInsets.only(top:10 ,left: 20 ,right: 20),
      padding: EdgeInsets.all(20),
      width: 250,
       height: 180,
       decoration: BoxDecoration(
         color: modelDashboard.primary ,// Color(0xff3F51B5) ,
             borderRadius: BorderRadius.circular(25)
       ),
       child:  Stack(
         children: [
           Container(
             padding:  EdgeInsets.all(20),
             decoration: BoxDecoration(
                 color:  modelDashboard.basic,//Color(0xffFAFAFA) ,
                 borderRadius: BorderRadius.circular(25)
             ),
             child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text("Computer Science Development " ,style:displaySmall) ,
               SizedBox(height: 5,),
               Text(modelDashboard.name,style:displaySmall),
               SizedBox(height: 5,),
               Text(modelDashboard.complete,style:displaySmall)],
           ),),
         ],
       ),
    );
  }
}