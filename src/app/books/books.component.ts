import { Component, OnInit } from '@angular/core';
import {DataService} from '../core/services/data.service';
import {BooksService} from './services/books.service';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  constructor(private dataService: DataService,
              private booksService: BooksService) {
  }

  ngOnInit(): void {
    this.createBook();
    this.getBooksByOwner();
  }
  createBook() {
    this.booksService.createBook(12345, 'Test');
  }
  getBooksByOwner() {
    this.booksService.getBooksByOwner();
  }

}
