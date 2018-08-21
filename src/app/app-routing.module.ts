import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';


@NgModule({
  imports: [
    RouterModule.forRoot([
    {
      path: '',
      pathMatch: 'full',
      redirectTo: '/books',
    }
    ])
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }
