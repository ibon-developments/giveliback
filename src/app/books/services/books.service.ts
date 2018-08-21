import {Injectable} from '@angular/core';
import {DataService} from '../../core/services/data.service';
import {HttpParams} from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class BooksService {

  constructor(private dataService: DataService) {
  }
  createBook(isbn: number, bookName: string) {
    let params = new HttpParams();
    params = params.append('isbn', isbn.toString());
    params = params.append('book_name', bookName);
    this.dataService.getWithParameters('http://127.0.0.1:8888/create_book', params).subscribe((data) => {
      if (data) {
        console.log(data);
      }
    });
  }
  getBooksByOwner() {
    this.dataService.get('http://127.0.0.1:8888/get_books_by_owner').subscribe((data) => {
      if (data) {
        console.log(data);
      }
    });
  }
}
