import 'package:flutter/material.dart';

import '../../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))) ||
          (!_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpeg') &&
              !_imageUrlController.text.endsWith('jpg'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      debugPrint('${_editedProduct.title}');
      debugPrint('${_editedProduct.description}');
      debugPrint('${_editedProduct.imageUrl}');
      debugPrint('${_editedProduct.price}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      id: null,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      id: null,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Plaese enter a valid number';
                    }
                    if (double.parse(value) >= 0) {
                      return 'Please enter a number  greater than 0';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      description: value,
                      id: null,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Should be atleaset 10 characters long';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => _saveForm,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            imageUrl: value,
                            description: _editedProduct.description,
                            id: null,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL.';
                          }
                          if (!value.endsWith('png') &&
                              !value.endsWith('jpeg') &&
                              !value.endsWith('jpg')) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
