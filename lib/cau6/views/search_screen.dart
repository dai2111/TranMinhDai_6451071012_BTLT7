import 'dart:async';
import 'package:flutter/material.dart';
import '../models/search_product.dart';
import '../utils/search_api_service.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchApiService _api = SearchApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  List<SearchProduct> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String _error = '';
  Timer? _debounce;

  final List<String> _categories = [
    'electronics',
    "men's clothing",
    "women's clothing",
    'jewelery',
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load all on open
    _search('');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(value);
    });
  }

  Future<void> _search(String keyword) async {
    setState(() {
      _isLoading = true;
      _error = '';
      _hasSearched = true;
      _selectedCategory = null;
    });

    try {
      final results = await _api.searchProducts(keyword);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _filterByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _error = '';
      _selectedCategory = category;
      _searchCtrl.clear();
    });

    try {
      final results = await _api.fetchByCategory(category);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text('Tìm Kiếm Sản Phẩm',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.pink,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextFormField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Nhập tên sản phẩm hoặc danh mục...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Colors.pink),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: Colors.grey),
                      onPressed: () {
                        _searchCtrl.clear();
                        _search('');
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category chips
          Container(
            color: Colors.pink.shade50,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => _filterByCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.pink : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.pink
                              : Colors.pink.shade200,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          color:
                          isSelected ? Colors.white : Colors.pink,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Results count
          if (!_isLoading && _hasSearched && _error.isEmpty)
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Tìm thấy ${_results.length} sản phẩm',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.pink),
                  SizedBox(height: 16),
                  Text('Đang tìm kiếm...',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 14)),
                ],
              ),
            )
                : _error.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Không thể kết nối'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        _search(_searchCtrl.text),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
                : _results.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Không tìm thấy kết quả',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'Thử tìm với từ khóa khác',
                    style: TextStyle(
                        color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(
                  top: 4, bottom: 16),
              itemCount: _results.length,
              itemBuilder: (context, index) =>
                  SearchResultCard(
                      product: _results[index]),
            ),
          ),
        ],
      ),
    );
  }
}