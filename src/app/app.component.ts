import {Component, OnInit} from '@angular/core';
import {DataService} from './core/services/data.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'app';

  constructor(private dataService: DataService) {
  }

  ngOnInit(): void {
    this.dataService.get('http://127.0.0.1:8888/get_books_by_owner').subscribe((data) => {
      if (data) {
        console.log(data);
      }
    });
    this.dataService.get('http://127.0.0.1:8888/create_book?book_name=test&isbn=981299902').subscribe((data) => {
      if (data) {
        console.log(data);
      }
    });
  }
}
