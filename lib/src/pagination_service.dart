class Pagination {
  // int _current;
  int _page;
  int _limit;
  int _count;

  List<dynamic> _data;

  Pagination(this._page, this._limit, this._count, this._data);

  
  // void goToPage(int to){
  //   if(to >= 1 && to < _page)
  //     _current = to;
  // }

  // int getOffset() => (_current - 1) * _limit;
  int getPage() => _page;
  int getLimit() => _limit;
  int getRecordCount() => _count;
  List<dynamic> getData() => _data;

  void setPage(int page) => _page = page;
  void setLimit(int limit) => _limit = limit;
  void setRecordCount(int count) => _count = count;

  // void nextPage() {
  //   if(_current < _page)
  //     _current++;
  // }

  // void prevPage() {
  //   if(_current > 1) {
  //     _current--;
  //   }
  // }
}