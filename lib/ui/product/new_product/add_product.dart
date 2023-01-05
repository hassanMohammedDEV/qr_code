import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_app/model/product_model.dart';
import 'package:qr_code_app/ui/product/widgets/qr_reader.dart';

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
              });
            }, child: const Text('save')),
            Expanded(child: Text('${products.length}')),
            const SizedBox(height: 5,),
            ElevatedButton(onPressed: ()async{
              await _barcode();
              product = products.firstWhere((element) => element.qrCode== barcodeScanResult);
              setState((){});
            },
                child: const Text('find product'),
            ),
            product!=null
            ?Text('name ${product!.name} price ${product!.price}',style: const TextStyle(color: Colors.green),)
                :const SizedBox()
          ],
        ),
      ),
    );
  }


}
