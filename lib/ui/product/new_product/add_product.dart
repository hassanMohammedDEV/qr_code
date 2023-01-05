import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_app/model/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String barcodeScanResult="0";

  List<ProductModel>  products=[];
  ProductModel? product;

  _barcode()async{
    barcodeScanResult=
        await FlutterBarcodeScanner.scanBarcode(
            "", "done", false, ScanMode.DEFAULT);
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text('product id'),
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: idController,
                )),
                Expanded(child: IconButton(onPressed: ()async{
                  await _barcode();
                  idController.text=barcodeScanResult;
                  product=null;
                  setState((){});
                }, icon: const Icon(Icons.qr_code)))
              ],
            ),
            const SizedBox(height: 20,),
            const Text('product name'),
            Expanded(child: TextFormField(
              controller: nameController,
            )),
            const Text('product price'),
            Expanded(child: TextFormField(
              controller: priceController,
            )),
            ElevatedButton(onPressed: (){
              setState(() {
                products.add(ProductModel(idController.text, nameController.text,double.parse(priceController.text)));
                product =null;
                idController.text='';
                nameController.text='';
                priceController.text='';
              });
            }, child: const Text('save')),
            Expanded(child: Text('${products.length}')),
            const SizedBox(height: 5,),
            ElevatedButton(onPressed: ()async{
              barcodeScanResult="0";
              product =null;
              await _barcode();
              if(barcodeScanResult!="0")
                {
                  product = products.firstWhere((element) => element.qrCode== barcodeScanResult);
                }
              else
                {
                  product = ProductModel('000', 'لا توجد نتائج', 00);
                }
              idController.text='';
              nameController.text='';
              priceController.text='';
              setState((){});
            },
                child: const Text('find product'),
            ),
            product!=null
            ?Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('نتيجة البحث',style: TextStyle(color: Colors.green),),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Text('اسم الصنف :',style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 5,),
                        Text(product!.name,style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('سعر الصنف :',style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 5,),
                        Text(product!.price.toString(),style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            )
                :const SizedBox()
          ],
        ),
      ),
    );
  }


}
