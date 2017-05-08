
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a8 37 10 80       	mov    $0x801037a8,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 90 84 10 	movl   $0x80108490,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 24 4e 00 00       	call   80104e72 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100055:	05 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
8010005f:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 74 05 11 80       	mov    0x80110574,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 d1 4d 00 00       	call   80104e93 <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 74 05 11 80       	mov    0x80110574,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->blockno == blockno){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 ec 4d 00 00       	call   80104ef5 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 9b 4a 00 00       	call   80104bbf <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 70 05 11 80       	mov    0x80110570,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 74 4d 00 00       	call   80104ef5 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 97 84 10 80 	movl   $0x80108497,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 64 26 00 00       	call   8010283c <iderw>
  }
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 a8 84 10 80 	movl   $0x801084a8,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 27 26 00 00       	call   8010283c <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 af 84 10 80 	movl   $0x801084af,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 52 4c 00 00       	call   80104e93 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 74 05 11 80       	mov    0x80110574,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 f6 49 00 00       	call   80104c98 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 47 4c 00 00       	call   80104ef5 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 d3 4a 00 00       	call   80104e93 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 b6 84 10 80 	movl   $0x801084b6,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec bf 84 10 80 	movl   $0x801084bf,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 bd 49 00 00       	call   80104ef5 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 c6 84 10 80 	movl   $0x801084c6,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 d5 84 10 80 	movl   $0x801084d5,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 b0 49 00 00       	call   80104f44 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 d7 84 10 80 	movl   $0x801084d7,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 09 4b 00 00       	call   801051c0 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 0b 4a 00 00       	call   801050f1 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 58 63 00 00       	call   80106ad3 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 4c 63 00 00       	call   80106ad3 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 40 63 00 00       	call   80106ad3 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 33 63 00 00       	call   80106ad3 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
801007ba:	e8 d4 46 00 00       	call   80104e93 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 4c 45 00 00       	call   80104d3b <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100816:	a1 38 08 11 80       	mov    0x80110838,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 3c 08 11 80       	mov    0x8011083c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
80100840:	a1 38 08 11 80       	mov    0x80110838,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 3c 08 11 80       	mov    0x8011083c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 3c 08 11 80       	mov    %eax,0x8011083c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 3c 08 11 80    	mov    0x8011083c,%edx
8010087c:	a1 34 08 11 80       	mov    0x80110834,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 3c 08 11 80    	mov    %edx,0x8011083c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 b4 07 11 80    	mov    %al,-0x7feef84c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008d5:	8b 15 34 08 11 80    	mov    0x80110834,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 3c 08 11 80       	mov    0x8011083c,%eax
801008e7:	a3 38 08 11 80       	mov    %eax,0x80110838
          wakeup(&input.r);
801008ec:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
801008f3:	e8 a0 43 00 00       	call   80104c98 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100914:	e8 dc 45 00 00       	call   80104ef5 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 e1 10 00 00       	call   80101a0d <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100939:	e8 55 45 00 00       	call   80104e93 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100959:	e8 97 45 00 00       	call   80104ef5 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 50 0f 00 00       	call   801018b9 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 80 07 11 	movl   $0x80110780,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 34 08 11 80 	movl   $0x80110834,(%esp)
80100982:	e8 38 42 00 00       	call   80104bbf <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 34 08 11 80    	mov    0x80110834,%edx
8010098d:	a1 38 08 11 80       	mov    0x80110838,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 34 08 11 80       	mov    0x80110834,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 34 08 11 80    	mov    %edx,0x80110834
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 b4 07 11 80 	movzbl -0x7feef84c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 34 08 11 80       	mov    0x80110834,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 34 08 11 80       	mov    %eax,0x80110834
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
801009fe:	e8 f2 44 00 00       	call   80104ef5 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 ab 0e 00 00       	call   801018b9 <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 e2 0f 00 00       	call   80101a0d <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a32:	e8 5c 44 00 00       	call   80104e93 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6c:	e8 84 44 00 00       	call   80104ef5 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 3d 0e 00 00       	call   801018b9 <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 db 84 10 	movl   $0x801084db,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a96:	e8 d7 43 00 00       	call   80104e72 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 e3 84 10 	movl   $0x801084e3,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 80 07 11 80 	movl   $0x80110780,(%esp)
80100aaa:	e8 c3 43 00 00       	call   80104e72 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 ec 11 11 80 1a 	movl   $0x80100a1a,0x801111ec
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 e8 11 11 80 1b 	movl   $0x8010091b,0x801111e8
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 67 33 00 00       	call   80103e40 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 0b 1f 00 00       	call   801029f8 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100af8:	e8 a4 29 00 00       	call   801034a1 <begin_op>
  if((ip = namei(path)) == 0){
80100afd:	8b 45 08             	mov    0x8(%ebp),%eax
80100b00:	89 04 24             	mov    %eax,(%esp)
80100b03:	e8 62 19 00 00       	call   8010246a <namei>
80100b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0f:	75 0f                	jne    80100b20 <exec+0x31>
    end_op();
80100b11:	e8 0f 2a 00 00       	call   80103525 <end_op>
    return -1;
80100b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1b:	e9 e8 03 00 00       	jmp    80100f08 <exec+0x419>
  }
  ilock(ip);
80100b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b23:	89 04 24             	mov    %eax,(%esp)
80100b26:	e8 8e 0d 00 00       	call   801018b9 <ilock>
  pgdir = 0;
80100b2b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b32:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b39:	00 
80100b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b41:	00 
80100b42:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b4f:	89 04 24             	mov    %eax,(%esp)
80100b52:	e8 75 12 00 00       	call   80101dcc <readi>
80100b57:	83 f8 33             	cmp    $0x33,%eax
80100b5a:	77 05                	ja     80100b61 <exec+0x72>
    goto bad;
80100b5c:	e9 7b 03 00 00       	jmp    80100edc <exec+0x3ed>
  if(elf.magic != ELF_MAGIC)
80100b61:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b67:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6c:	74 05                	je     80100b73 <exec+0x84>
    goto bad;
80100b6e:	e9 69 03 00 00       	jmp    80100edc <exec+0x3ed>

  if((pgdir = setupkvm()) == 0)
80100b73:	e8 ac 70 00 00       	call   80107c24 <setupkvm>
80100b78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7f:	75 05                	jne    80100b86 <exec+0x97>
    goto bad;
80100b81:	e9 56 03 00 00       	jmp    80100edc <exec+0x3ed>

  // Load program into memory.
  sz = 0;
80100b86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b94:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9d:	e9 cb 00 00 00       	jmp    80100c6d <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba5:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bac:	00 
80100bad:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb1:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbe:	89 04 24             	mov    %eax,(%esp)
80100bc1:	e8 06 12 00 00       	call   80101dcc <readi>
80100bc6:	83 f8 20             	cmp    $0x20,%eax
80100bc9:	74 05                	je     80100bd0 <exec+0xe1>
      goto bad;
80100bcb:	e9 0c 03 00 00       	jmp    80100edc <exec+0x3ed>
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd6:	83 f8 01             	cmp    $0x1,%eax
80100bd9:	74 05                	je     80100be0 <exec+0xf1>
      continue;
80100bdb:	e9 80 00 00 00       	jmp    80100c60 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be0:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be6:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bec:	39 c2                	cmp    %eax,%edx
80100bee:	73 05                	jae    80100bf5 <exec+0x106>
      goto bad;
80100bf0:	e9 e7 02 00 00       	jmp    80100edc <exec+0x3ed>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf5:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfb:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c01:	01 d0                	add    %edx,%eax
80100c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 d9 73 00 00       	call   80107ff2 <allocuvm>
80100c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c20:	75 05                	jne    80100c27 <exec+0x138>
      goto bad;
80100c22:	e9 b5 02 00 00       	jmp    80100edc <exec+0x3ed>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c27:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c41:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c44:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4f:	89 04 24             	mov    %eax,(%esp)
80100c52:	e8 b0 72 00 00       	call   80107f07 <loaduvm>
80100c57:	85 c0                	test   %eax,%eax
80100c59:	79 05                	jns    80100c60 <exec+0x171>
      goto bad;
80100c5b:	e9 7c 02 00 00       	jmp    80100edc <exec+0x3ed>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c60:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c67:	83 c0 20             	add    $0x20,%eax
80100c6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6d:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c74:	0f b7 c0             	movzwl %ax,%eax
80100c77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7a:	0f 8f 22 ff ff ff    	jg     80100ba2 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c83:	89 04 24             	mov    %eax,(%esp)
80100c86:	e8 b8 0e 00 00       	call   80101b43 <iunlockput>
  end_op();
80100c8b:	e8 95 28 00 00       	call   80103525 <end_op>
  ip = 0;
80100c90:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100caa:	05 00 20 00 00       	add    $0x2000,%eax
80100caf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 2d 73 00 00       	call   80107ff2 <allocuvm>
80100cc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccc:	75 05                	jne    80100cd3 <exec+0x1e4>
    goto bad;
80100cce:	e9 09 02 00 00       	jmp    80100edc <exec+0x3ed>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 38 75 00 00       	call   80108222 <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf7:	e9 9a 00 00 00       	jmp    80100d96 <exec+0x2a7>
    if(argc >= MAXARG)
80100cfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d00:	76 05                	jbe    80100d07 <exec+0x218>
      goto bad;
80100d02:	e9 d5 01 00 00       	jmp    80100edc <exec+0x3ed>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d14:	01 d0                	add    %edx,%eax
80100d16:	8b 00                	mov    (%eax),%eax
80100d18:	89 04 24             	mov    %eax,(%esp)
80100d1b:	e8 3b 46 00 00       	call   8010535b <strlen>
80100d20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d23:	29 c2                	sub    %eax,%edx
80100d25:	89 d0                	mov    %edx,%eax
80100d27:	83 e8 01             	sub    $0x1,%eax
80100d2a:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3d:	01 d0                	add    %edx,%eax
80100d3f:	8b 00                	mov    (%eax),%eax
80100d41:	89 04 24             	mov    %eax,(%esp)
80100d44:	e8 12 46 00 00       	call   8010535b <strlen>
80100d49:	83 c0 01             	add    $0x1,%eax
80100d4c:	89 c2                	mov    %eax,%edx
80100d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d51:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5b:	01 c8                	add    %ecx,%eax
80100d5d:	8b 00                	mov    (%eax),%eax
80100d5f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d71:	89 04 24             	mov    %eax,(%esp)
80100d74:	e8 6e 76 00 00       	call   801083e7 <copyout>
80100d79:	85 c0                	test   %eax,%eax
80100d7b:	79 05                	jns    80100d82 <exec+0x293>
      goto bad;
80100d7d:	e9 5a 01 00 00       	jmp    80100edc <exec+0x3ed>
    ustack[3+argc] = sp;
80100d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d85:	8d 50 03             	lea    0x3(%eax),%edx
80100d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8b:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d92:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da3:	01 d0                	add    %edx,%eax
80100da5:	8b 00                	mov    (%eax),%eax
80100da7:	85 c0                	test   %eax,%eax
80100da9:	0f 85 4d ff ff ff    	jne    80100cfc <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db2:	83 c0 03             	add    $0x3,%eax
80100db5:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbc:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc0:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc7:	ff ff ff 
  ustack[1] = argc;
80100dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcd:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd6:	83 c0 01             	add    $0x1,%eax
80100dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de3:	29 d0                	sub    %edx,%eax
80100de5:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dee:	83 c0 04             	add    $0x4,%eax
80100df1:	c1 e0 02             	shl    $0x2,%eax
80100df4:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfa:	83 c0 04             	add    $0x4,%eax
80100dfd:	c1 e0 02             	shl    $0x2,%eax
80100e00:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e04:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e11:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e18:	89 04 24             	mov    %eax,(%esp)
80100e1b:	e8 c7 75 00 00       	call   801083e7 <copyout>
80100e20:	85 c0                	test   %eax,%eax
80100e22:	79 05                	jns    80100e29 <exec+0x33a>
    goto bad;
80100e24:	e9 b3 00 00 00       	jmp    80100edc <exec+0x3ed>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e29:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e35:	eb 17                	jmp    80100e4e <exec+0x35f>
    if(*s == '/')
80100e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3a:	0f b6 00             	movzbl (%eax),%eax
80100e3d:	3c 2f                	cmp    $0x2f,%al
80100e3f:	75 09                	jne    80100e4a <exec+0x35b>
      last = s+1;
80100e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e44:	83 c0 01             	add    $0x1,%eax
80100e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e51:	0f b6 00             	movzbl (%eax),%eax
80100e54:	84 c0                	test   %al,%al
80100e56:	75 df                	jne    80100e37 <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5e:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e68:	00 
80100e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e70:	89 14 24             	mov    %edx,(%esp)
80100e73:	e8 99 44 00 00       	call   80105311 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7e:	8b 40 04             	mov    0x4(%eax),%eax
80100e81:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e8d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e99:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea1:	8b 40 18             	mov    0x18(%eax),%eax
80100ea4:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eaa:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb3:	8b 40 18             	mov    0x18(%eax),%eax
80100eb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec2:	89 04 24             	mov    %eax,(%esp)
80100ec5:	e8 4b 6e 00 00       	call   80107d15 <switchuvm>
  freevm(oldpgdir);
80100eca:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 b3 72 00 00       	call   80108188 <freevm>
  return 0;
80100ed5:	b8 00 00 00 00       	mov    $0x0,%eax
80100eda:	eb 2c                	jmp    80100f08 <exec+0x419>

 bad:
  if(pgdir)
80100edc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ee0:	74 0b                	je     80100eed <exec+0x3fe>
    freevm(pgdir);
80100ee2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ee5:	89 04 24             	mov    %eax,(%esp)
80100ee8:	e8 9b 72 00 00       	call   80108188 <freevm>
  if(ip){
80100eed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ef1:	74 10                	je     80100f03 <exec+0x414>
    iunlockput(ip);
80100ef3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef6:	89 04 24             	mov    %eax,(%esp)
80100ef9:	e8 45 0c 00 00       	call   80101b43 <iunlockput>
    end_op();
80100efe:	e8 22 26 00 00       	call   80103525 <end_op>
  }
  return -1;
80100f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    

80100f0a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f0a:	55                   	push   %ebp
80100f0b:	89 e5                	mov    %esp,%ebp
80100f0d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f10:	c7 44 24 04 e9 84 10 	movl   $0x801084e9,0x4(%esp)
80100f17:	80 
80100f18:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f1f:	e8 4e 3f 00 00       	call   80104e72 <initlock>
}
80100f24:	c9                   	leave  
80100f25:	c3                   	ret    

80100f26 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f26:	55                   	push   %ebp
80100f27:	89 e5                	mov    %esp,%ebp
80100f29:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f2c:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f33:	e8 5b 3f 00 00       	call   80104e93 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f38:	c7 45 f4 74 08 11 80 	movl   $0x80110874,-0xc(%ebp)
80100f3f:	eb 29                	jmp    80100f6a <filealloc+0x44>
    if(f->ref == 0){
80100f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f44:	8b 40 04             	mov    0x4(%eax),%eax
80100f47:	85 c0                	test   %eax,%eax
80100f49:	75 1b                	jne    80100f66 <filealloc+0x40>
      f->ref = 1;
80100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f4e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f55:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f5c:	e8 94 3f 00 00       	call   80104ef5 <release>
      return f;
80100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f64:	eb 1e                	jmp    80100f84 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f66:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f6a:	81 7d f4 d4 11 11 80 	cmpl   $0x801111d4,-0xc(%ebp)
80100f71:	72 ce                	jb     80100f41 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f73:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f7a:	e8 76 3f 00 00       	call   80104ef5 <release>
  return 0;
80100f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f84:	c9                   	leave  
80100f85:	c3                   	ret    

80100f86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f86:	55                   	push   %ebp
80100f87:	89 e5                	mov    %esp,%ebp
80100f89:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f8c:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100f93:	e8 fb 3e 00 00       	call   80104e93 <acquire>
  if(f->ref < 1)
80100f98:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9b:	8b 40 04             	mov    0x4(%eax),%eax
80100f9e:	85 c0                	test   %eax,%eax
80100fa0:	7f 0c                	jg     80100fae <filedup+0x28>
    panic("filedup");
80100fa2:	c7 04 24 f0 84 10 80 	movl   $0x801084f0,(%esp)
80100fa9:	e8 8c f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fae:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb1:	8b 40 04             	mov    0x4(%eax),%eax
80100fb4:	8d 50 01             	lea    0x1(%eax),%edx
80100fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80100fba:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fbd:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fc4:	e8 2c 3f 00 00       	call   80104ef5 <release>
  return f;
80100fc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fcc:	c9                   	leave  
80100fcd:	c3                   	ret    

80100fce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fce:	55                   	push   %ebp
80100fcf:	89 e5                	mov    %esp,%ebp
80100fd1:	83 ec 38             	sub    $0x38,%esp
  struct file ff;
  acquire(&ftable.lock);
80100fd4:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80100fdb:	e8 b3 3e 00 00       	call   80104e93 <acquire>
  if(f->ref < 1)
80100fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe3:	8b 40 04             	mov    0x4(%eax),%eax
80100fe6:	85 c0                	test   %eax,%eax
80100fe8:	7f 0c                	jg     80100ff6 <fileclose+0x28>
    panic("fileclose");
80100fea:	c7 04 24 f8 84 10 80 	movl   $0x801084f8,(%esp)
80100ff1:	e8 44 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff9:	8b 40 04             	mov    0x4(%eax),%eax
80100ffc:	8d 50 ff             	lea    -0x1(%eax),%edx
80100fff:	8b 45 08             	mov    0x8(%ebp),%eax
80101002:	89 50 04             	mov    %edx,0x4(%eax)
80101005:	8b 45 08             	mov    0x8(%ebp),%eax
80101008:	8b 40 04             	mov    0x4(%eax),%eax
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7e 11                	jle    80101020 <fileclose+0x52>
    release(&ftable.lock);
8010100f:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80101016:	e8 da 3e 00 00       	call   80104ef5 <release>
8010101b:	e9 82 00 00 00       	jmp    801010a2 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101020:	8b 45 08             	mov    0x8(%ebp),%eax
80101023:	8b 10                	mov    (%eax),%edx
80101025:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101028:	8b 50 04             	mov    0x4(%eax),%edx
8010102b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010102e:	8b 50 08             	mov    0x8(%eax),%edx
80101031:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101034:	8b 50 0c             	mov    0xc(%eax),%edx
80101037:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010103a:	8b 50 10             	mov    0x10(%eax),%edx
8010103d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101040:	8b 40 14             	mov    0x14(%eax),%eax
80101043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101050:	8b 45 08             	mov    0x8(%ebp),%eax
80101053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101059:	c7 04 24 40 08 11 80 	movl   $0x80110840,(%esp)
80101060:	e8 90 3e 00 00       	call   80104ef5 <release>
  
  if(ff.type == FD_PIPE)
80101065:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101068:	83 f8 01             	cmp    $0x1,%eax
8010106b:	75 18                	jne    80101085 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010106d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101071:	0f be d0             	movsbl %al,%edx
80101074:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101077:	89 54 24 04          	mov    %edx,0x4(%esp)
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 6d 30 00 00       	call   801040f0 <pipeclose>
80101083:	eb 1d                	jmp    801010a2 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101085:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101088:	83 f8 02             	cmp    $0x2,%eax
8010108b:	75 15                	jne    801010a2 <fileclose+0xd4>
    begin_op();
8010108d:	e8 0f 24 00 00       	call   801034a1 <begin_op>
    iput(ff.ip);
80101092:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101095:	89 04 24             	mov    %eax,(%esp)
80101098:	e8 d5 09 00 00       	call   80101a72 <iput>
    end_op();
8010109d:	e8 83 24 00 00       	call   80103525 <end_op>
  }
}
801010a2:	c9                   	leave  
801010a3:	c3                   	ret    

801010a4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 00                	mov    (%eax),%eax
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 38                	jne    801010ec <filestat+0x48>
    ilock(f->ip);
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	8b 40 10             	mov    0x10(%eax),%eax
801010ba:	89 04 24             	mov    %eax,(%esp)
801010bd:	e8 f7 07 00 00       	call   801018b9 <ilock>
    stati(f->ip, st);
801010c2:	8b 45 08             	mov    0x8(%ebp),%eax
801010c5:	8b 40 10             	mov    0x10(%eax),%eax
801010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801010cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801010cf:	89 04 24             	mov    %eax,(%esp)
801010d2:	e8 b0 0c 00 00       	call   80101d87 <stati>
    iunlock(f->ip);
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 10             	mov    0x10(%eax),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 28 09 00 00       	call   80101a0d <iunlock>
    return 0;
801010e5:	b8 00 00 00 00       	mov    $0x0,%eax
801010ea:	eb 05                	jmp    801010f1 <filestat+0x4d>
  }
  return -1;
801010ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010f1:	c9                   	leave  
801010f2:	c3                   	ret    

801010f3 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010f3:	55                   	push   %ebp
801010f4:	89 e5                	mov    %esp,%ebp
801010f6:	83 ec 28             	sub    $0x28,%esp
  int r;
  if(f->readable == 0)
801010f9:	8b 45 08             	mov    0x8(%ebp),%eax
801010fc:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101100:	84 c0                	test   %al,%al
80101102:	75 0a                	jne    8010110e <fileread+0x1b>
    return -1;
80101104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101109:	e9 9f 00 00 00       	jmp    801011ad <fileread+0xba>
  if(f->type == FD_PIPE)
8010110e:	8b 45 08             	mov    0x8(%ebp),%eax
80101111:	8b 00                	mov    (%eax),%eax
80101113:	83 f8 01             	cmp    $0x1,%eax
80101116:	75 1e                	jne    80101136 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 0c             	mov    0xc(%eax),%eax
8010111e:	8b 55 10             	mov    0x10(%ebp),%edx
80101121:	89 54 24 08          	mov    %edx,0x8(%esp)
80101125:	8b 55 0c             	mov    0xc(%ebp),%edx
80101128:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112c:	89 04 24             	mov    %eax,(%esp)
8010112f:	e8 3d 31 00 00       	call   80104271 <piperead>
80101134:	eb 77                	jmp    801011ad <fileread+0xba>
  if(f->type == FD_INODE){
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 00                	mov    (%eax),%eax
8010113b:	83 f8 02             	cmp    $0x2,%eax
8010113e:	75 61                	jne    801011a1 <fileread+0xae>
    ilock(f->ip);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 10             	mov    0x10(%eax),%eax
80101146:	89 04 24             	mov    %eax,(%esp)
80101149:	e8 6b 07 00 00       	call   801018b9 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010114e:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101151:	8b 45 08             	mov    0x8(%ebp),%eax
80101154:	8b 50 14             	mov    0x14(%eax),%edx
80101157:	8b 45 08             	mov    0x8(%ebp),%eax
8010115a:	8b 40 10             	mov    0x10(%eax),%eax
8010115d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101161:	89 54 24 08          	mov    %edx,0x8(%esp)
80101165:	8b 55 0c             	mov    0xc(%ebp),%edx
80101168:	89 54 24 04          	mov    %edx,0x4(%esp)
8010116c:	89 04 24             	mov    %eax,(%esp)
8010116f:	e8 58 0c 00 00       	call   80101dcc <readi>
80101174:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010117b:	7e 11                	jle    8010118e <fileread+0x9b>
      f->off += r;
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	8b 50 14             	mov    0x14(%eax),%edx
80101183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101186:	01 c2                	add    %eax,%edx
80101188:	8b 45 08             	mov    0x8(%ebp),%eax
8010118b:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010118e:	8b 45 08             	mov    0x8(%ebp),%eax
80101191:	8b 40 10             	mov    0x10(%eax),%eax
80101194:	89 04 24             	mov    %eax,(%esp)
80101197:	e8 71 08 00 00       	call   80101a0d <iunlock>
    return r;
8010119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119f:	eb 0c                	jmp    801011ad <fileread+0xba>
  }
  panic("fileread");
801011a1:	c7 04 24 02 85 10 80 	movl   $0x80108502,(%esp)
801011a8:	e8 8d f3 ff ff       	call   8010053a <panic>
}
801011ad:	c9                   	leave  
801011ae:	c3                   	ret    

801011af <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011af:	55                   	push   %ebp
801011b0:	89 e5                	mov    %esp,%ebp
801011b2:	53                   	push   %ebx
801011b3:	83 ec 24             	sub    $0x24,%esp
  int r;
  if(f->writable == 0)
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011bd:	84 c0                	test   %al,%al
801011bf:	75 0a                	jne    801011cb <filewrite+0x1c>
    return -1;
801011c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011c6:	e9 20 01 00 00       	jmp    801012eb <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 00                	mov    (%eax),%eax
801011d0:	83 f8 01             	cmp    $0x1,%eax
801011d3:	75 21                	jne    801011f6 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011d5:	8b 45 08             	mov    0x8(%ebp),%eax
801011d8:	8b 40 0c             	mov    0xc(%eax),%eax
801011db:	8b 55 10             	mov    0x10(%ebp),%edx
801011de:	89 54 24 08          	mov    %edx,0x8(%esp)
801011e2:	8b 55 0c             	mov    0xc(%ebp),%edx
801011e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e9:	89 04 24             	mov    %eax,(%esp)
801011ec:	e8 91 2f 00 00       	call   80104182 <pipewrite>
801011f1:	e9 f5 00 00 00       	jmp    801012eb <filewrite+0x13c>
  if(f->type == FD_INODE){
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 00                	mov    (%eax),%eax
801011fb:	83 f8 02             	cmp    $0x2,%eax
801011fe:	0f 85 db 00 00 00    	jne    801012df <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101204:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010120b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101212:	e9 a8 00 00 00       	jmp    801012bf <filewrite+0x110>
      int n1 = n - i;
80101217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121a:	8b 55 10             	mov    0x10(%ebp),%edx
8010121d:	29 c2                	sub    %eax,%edx
8010121f:	89 d0                	mov    %edx,%eax
80101221:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101224:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101227:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010122a:	7e 06                	jle    80101232 <filewrite+0x83>
        n1 = max;
8010122c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010122f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101232:	e8 6a 22 00 00       	call   801034a1 <begin_op>
      ilock(f->ip);
80101237:	8b 45 08             	mov    0x8(%ebp),%eax
8010123a:	8b 40 10             	mov    0x10(%eax),%eax
8010123d:	89 04 24             	mov    %eax,(%esp)
80101240:	e8 74 06 00 00       	call   801018b9 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101245:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101248:	8b 45 08             	mov    0x8(%ebp),%eax
8010124b:	8b 50 14             	mov    0x14(%eax),%edx
8010124e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101251:	8b 45 0c             	mov    0xc(%ebp),%eax
80101254:	01 c3                	add    %eax,%ebx
80101256:	8b 45 08             	mov    0x8(%ebp),%eax
80101259:	8b 40 10             	mov    0x10(%eax),%eax
8010125c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101260:	89 54 24 08          	mov    %edx,0x8(%esp)
80101264:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101268:	89 04 24             	mov    %eax,(%esp)
8010126b:	e8 c0 0c 00 00       	call   80101f30 <writei>
80101270:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101273:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101277:	7e 11                	jle    8010128a <filewrite+0xdb>
        f->off += r;
80101279:	8b 45 08             	mov    0x8(%ebp),%eax
8010127c:	8b 50 14             	mov    0x14(%eax),%edx
8010127f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101282:	01 c2                	add    %eax,%edx
80101284:	8b 45 08             	mov    0x8(%ebp),%eax
80101287:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010128a:	8b 45 08             	mov    0x8(%ebp),%eax
8010128d:	8b 40 10             	mov    0x10(%eax),%eax
80101290:	89 04 24             	mov    %eax,(%esp)
80101293:	e8 75 07 00 00       	call   80101a0d <iunlock>
      end_op();
80101298:	e8 88 22 00 00       	call   80103525 <end_op>

      if(r < 0)
8010129d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a1:	79 02                	jns    801012a5 <filewrite+0xf6>
        break;
801012a3:	eb 26                	jmp    801012cb <filewrite+0x11c>
      if(r != n1)
801012a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012ab:	74 0c                	je     801012b9 <filewrite+0x10a>
        panic("short filewrite");
801012ad:	c7 04 24 0b 85 10 80 	movl   $0x8010850b,(%esp)
801012b4:	e8 81 f2 ff ff       	call   8010053a <panic>
      i += r;
801012b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012bc:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c2:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c5:	0f 8c 4c ff ff ff    	jl     80101217 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d1:	75 05                	jne    801012d8 <filewrite+0x129>
801012d3:	8b 45 10             	mov    0x10(%ebp),%eax
801012d6:	eb 05                	jmp    801012dd <filewrite+0x12e>
801012d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012dd:	eb 0c                	jmp    801012eb <filewrite+0x13c>
  }
  panic("filewrite");
801012df:	c7 04 24 1b 85 10 80 	movl   $0x8010851b,(%esp)
801012e6:	e8 4f f2 ff ff       	call   8010053a <panic>
}
801012eb:	83 c4 24             	add    $0x24,%esp
801012ee:	5b                   	pop    %ebx
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    

801012f1 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101301:	00 
80101302:	89 04 24             	mov    %eax,(%esp)
80101305:	e8 9c ee ff ff       	call   801001a6 <bread>
8010130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101310:	83 c0 18             	add    $0x18,%eax
80101313:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010131a:	00 
8010131b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101322:	89 04 24             	mov    %eax,(%esp)
80101325:	e8 96 3e 00 00       	call   801051c0 <memmove>
  brelse(bp);
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	89 04 24             	mov    %eax,(%esp)
80101330:	e8 e2 ee ff ff       	call   80100217 <brelse>
}
80101335:	c9                   	leave  
80101336:	c3                   	ret    

80101337 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101337:	55                   	push   %ebp
80101338:	89 e5                	mov    %esp,%ebp
8010133a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010133d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101340:	8b 45 08             	mov    0x8(%ebp),%eax
80101343:	89 54 24 04          	mov    %edx,0x4(%esp)
80101347:	89 04 24             	mov    %eax,(%esp)
8010134a:	e8 57 ee ff ff       	call   801001a6 <bread>
8010134f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101355:	83 c0 18             	add    $0x18,%eax
80101358:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010135f:	00 
80101360:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101367:	00 
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 81 3d 00 00       	call   801050f1 <memset>
  log_write(bp);
80101370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101373:	89 04 24             	mov    %eax,(%esp)
80101376:	e8 31 23 00 00       	call   801036ac <log_write>
  brelse(bp);
8010137b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137e:	89 04 24             	mov    %eax,(%esp)
80101381:	e8 91 ee ff ff       	call   80100217 <brelse>
}
80101386:	c9                   	leave  
80101387:	c3                   	ret    

80101388 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101388:	55                   	push   %ebp
80101389:	89 e5                	mov    %esp,%ebp
8010138b:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010138e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010139c:	e9 07 01 00 00       	jmp    801014a8 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
801013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013aa:	85 c0                	test   %eax,%eax
801013ac:	0f 48 c2             	cmovs  %edx,%eax
801013af:	c1 f8 0c             	sar    $0xc,%eax
801013b2:	89 c2                	mov    %eax,%edx
801013b4:	a1 58 12 11 80       	mov    0x80111258,%eax
801013b9:	01 d0                	add    %edx,%eax
801013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013bf:	8b 45 08             	mov    0x8(%ebp),%eax
801013c2:	89 04 24             	mov    %eax,(%esp)
801013c5:	e8 dc ed ff ff       	call   801001a6 <bread>
801013ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013d4:	e9 9d 00 00 00       	jmp    80101476 <balloc+0xee>
      m = 1 << (bi % 8);
801013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013dc:	99                   	cltd   
801013dd:	c1 ea 1d             	shr    $0x1d,%edx
801013e0:	01 d0                	add    %edx,%eax
801013e2:	83 e0 07             	and    $0x7,%eax
801013e5:	29 d0                	sub    %edx,%eax
801013e7:	ba 01 00 00 00       	mov    $0x1,%edx
801013ec:	89 c1                	mov    %eax,%ecx
801013ee:	d3 e2                	shl    %cl,%edx
801013f0:	89 d0                	mov    %edx,%eax
801013f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f8:	8d 50 07             	lea    0x7(%eax),%edx
801013fb:	85 c0                	test   %eax,%eax
801013fd:	0f 48 c2             	cmovs  %edx,%eax
80101400:	c1 f8 03             	sar    $0x3,%eax
80101403:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101406:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010140b:	0f b6 c0             	movzbl %al,%eax
8010140e:	23 45 e8             	and    -0x18(%ebp),%eax
80101411:	85 c0                	test   %eax,%eax
80101413:	75 5d                	jne    80101472 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
80101415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101418:	8d 50 07             	lea    0x7(%eax),%edx
8010141b:	85 c0                	test   %eax,%eax
8010141d:	0f 48 c2             	cmovs  %edx,%eax
80101420:	c1 f8 03             	sar    $0x3,%eax
80101423:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101426:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010142b:	89 d1                	mov    %edx,%ecx
8010142d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101430:	09 ca                	or     %ecx,%edx
80101432:	89 d1                	mov    %edx,%ecx
80101434:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101437:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010143b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010143e:	89 04 24             	mov    %eax,(%esp)
80101441:	e8 66 22 00 00       	call   801036ac <log_write>
        brelse(bp);
80101446:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101449:	89 04 24             	mov    %eax,(%esp)
8010144c:	e8 c6 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101454:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101457:	01 c2                	add    %eax,%edx
80101459:	8b 45 08             	mov    0x8(%ebp),%eax
8010145c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 cf fe ff ff       	call   80101337 <bzero>
        return b + bi;
80101468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146e:	01 d0                	add    %edx,%eax
80101470:	eb 52                	jmp    801014c4 <balloc+0x13c>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101472:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101476:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010147d:	7f 17                	jg     80101496 <balloc+0x10e>
8010147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101485:	01 d0                	add    %edx,%eax
80101487:	89 c2                	mov    %eax,%edx
80101489:	a1 40 12 11 80       	mov    0x80111240,%eax
8010148e:	39 c2                	cmp    %eax,%edx
80101490:	0f 82 43 ff ff ff    	jb     801013d9 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101496:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101499:	89 04 24             	mov    %eax,(%esp)
8010149c:	e8 76 ed ff ff       	call   80100217 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014a1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ab:	a1 40 12 11 80       	mov    0x80111240,%eax
801014b0:	39 c2                	cmp    %eax,%edx
801014b2:	0f 82 e9 fe ff ff    	jb     801013a1 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014b8:	c7 04 24 28 85 10 80 	movl   $0x80108528,(%esp)
801014bf:	e8 76 f0 ff ff       	call   8010053a <panic>
}
801014c4:	c9                   	leave  
801014c5:	c3                   	ret    

801014c6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c6:	55                   	push   %ebp
801014c7:	89 e5                	mov    %esp,%ebp
801014c9:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014cc:	c7 44 24 04 40 12 11 	movl   $0x80111240,0x4(%esp)
801014d3:	80 
801014d4:	8b 45 08             	mov    0x8(%ebp),%eax
801014d7:	89 04 24             	mov    %eax,(%esp)
801014da:	e8 12 fe ff ff       	call   801012f1 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014df:	8b 45 0c             	mov    0xc(%ebp),%eax
801014e2:	c1 e8 0c             	shr    $0xc,%eax
801014e5:	89 c2                	mov    %eax,%edx
801014e7:	a1 58 12 11 80       	mov    0x80111258,%eax
801014ec:	01 c2                	add    %eax,%edx
801014ee:	8b 45 08             	mov    0x8(%ebp),%eax
801014f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801014f5:	89 04 24             	mov    %eax,(%esp)
801014f8:	e8 a9 ec ff ff       	call   801001a6 <bread>
801014fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	25 ff 0f 00 00       	and    $0xfff,%eax
80101508:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010150b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150e:	99                   	cltd   
8010150f:	c1 ea 1d             	shr    $0x1d,%edx
80101512:	01 d0                	add    %edx,%eax
80101514:	83 e0 07             	and    $0x7,%eax
80101517:	29 d0                	sub    %edx,%eax
80101519:	ba 01 00 00 00       	mov    $0x1,%edx
8010151e:	89 c1                	mov    %eax,%ecx
80101520:	d3 e2                	shl    %cl,%edx
80101522:	89 d0                	mov    %edx,%eax
80101524:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152a:	8d 50 07             	lea    0x7(%eax),%edx
8010152d:	85 c0                	test   %eax,%eax
8010152f:	0f 48 c2             	cmovs  %edx,%eax
80101532:	c1 f8 03             	sar    $0x3,%eax
80101535:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101538:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010153d:	0f b6 c0             	movzbl %al,%eax
80101540:	23 45 ec             	and    -0x14(%ebp),%eax
80101543:	85 c0                	test   %eax,%eax
80101545:	75 0c                	jne    80101553 <bfree+0x8d>
    panic("freeing free block");
80101547:	c7 04 24 3e 85 10 80 	movl   $0x8010853e,(%esp)
8010154e:	e8 e7 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101556:	8d 50 07             	lea    0x7(%eax),%edx
80101559:	85 c0                	test   %eax,%eax
8010155b:	0f 48 c2             	cmovs  %edx,%eax
8010155e:	c1 f8 03             	sar    $0x3,%eax
80101561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101564:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101569:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010156c:	f7 d1                	not    %ecx
8010156e:	21 ca                	and    %ecx,%edx
80101570:	89 d1                	mov    %edx,%ecx
80101572:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101575:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010157c:	89 04 24             	mov    %eax,(%esp)
8010157f:	e8 28 21 00 00       	call   801036ac <log_write>
  brelse(bp);
80101584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101587:	89 04 24             	mov    %eax,(%esp)
8010158a:	e8 88 ec ff ff       	call   80100217 <brelse>
}
8010158f:	c9                   	leave  
80101590:	c3                   	ret    

80101591 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101591:	55                   	push   %ebp
80101592:	89 e5                	mov    %esp,%ebp
80101594:	57                   	push   %edi
80101595:	56                   	push   %esi
80101596:	53                   	push   %ebx
80101597:	83 ec 3c             	sub    $0x3c,%esp
  initlock(&icache.lock, "icache");
8010159a:	c7 44 24 04 51 85 10 	movl   $0x80108551,0x4(%esp)
801015a1:	80 
801015a2:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801015a9:	e8 c4 38 00 00       	call   80104e72 <initlock>
  readsb(dev, &sb);
801015ae:	c7 44 24 04 40 12 11 	movl   $0x80111240,0x4(%esp)
801015b5:	80 
801015b6:	8b 45 08             	mov    0x8(%ebp),%eax
801015b9:	89 04 24             	mov    %eax,(%esp)
801015bc:	e8 30 fd ff ff       	call   801012f1 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801015c1:	a1 58 12 11 80       	mov    0x80111258,%eax
801015c6:	8b 3d 54 12 11 80    	mov    0x80111254,%edi
801015cc:	8b 35 50 12 11 80    	mov    0x80111250,%esi
801015d2:	8b 1d 4c 12 11 80    	mov    0x8011124c,%ebx
801015d8:	8b 0d 48 12 11 80    	mov    0x80111248,%ecx
801015de:	8b 15 44 12 11 80    	mov    0x80111244,%edx
801015e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801015e7:	8b 15 40 12 11 80    	mov    0x80111240,%edx
801015ed:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801015f1:	89 7c 24 18          	mov    %edi,0x18(%esp)
801015f5:	89 74 24 14          	mov    %esi,0x14(%esp)
801015f9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801015fd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101604:	89 44 24 08          	mov    %eax,0x8(%esp)
80101608:	89 d0                	mov    %edx,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	c7 04 24 58 85 10 80 	movl   $0x80108558,(%esp)
80101615:	e8 86 ed ff ff       	call   801003a0 <cprintf>
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010161a:	83 c4 3c             	add    $0x3c,%esp
8010161d:	5b                   	pop    %ebx
8010161e:	5e                   	pop    %esi
8010161f:	5f                   	pop    %edi
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret    

80101622 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101622:	55                   	push   %ebp
80101623:	89 e5                	mov    %esp,%ebp
80101625:	83 ec 28             	sub    $0x28,%esp
80101628:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162b:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010162f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101636:	e9 9e 00 00 00       	jmp    801016d9 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
8010163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163e:	c1 e8 03             	shr    $0x3,%eax
80101641:	89 c2                	mov    %eax,%edx
80101643:	a1 54 12 11 80       	mov    0x80111254,%eax
80101648:	01 d0                	add    %edx,%eax
8010164a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010164e:	8b 45 08             	mov    0x8(%ebp),%eax
80101651:	89 04 24             	mov    %eax,(%esp)
80101654:	e8 4d eb ff ff       	call   801001a6 <bread>
80101659:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165f:	8d 50 18             	lea    0x18(%eax),%edx
80101662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101665:	83 e0 07             	and    $0x7,%eax
80101668:	c1 e0 06             	shl    $0x6,%eax
8010166b:	01 d0                	add    %edx,%eax
8010166d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101670:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101673:	0f b7 00             	movzwl (%eax),%eax
80101676:	66 85 c0             	test   %ax,%ax
80101679:	75 4f                	jne    801016ca <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
8010167b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101682:	00 
80101683:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010168a:	00 
8010168b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010168e:	89 04 24             	mov    %eax,(%esp)
80101691:	e8 5b 3a 00 00       	call   801050f1 <memset>
      dip->type = type;
80101696:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101699:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010169d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a3:	89 04 24             	mov    %eax,(%esp)
801016a6:	e8 01 20 00 00       	call   801036ac <log_write>
      brelse(bp);
801016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ae:	89 04 24             	mov    %eax,(%esp)
801016b1:	e8 61 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801016bd:	8b 45 08             	mov    0x8(%ebp),%eax
801016c0:	89 04 24             	mov    %eax,(%esp)
801016c3:	e8 ed 00 00 00       	call   801017b5 <iget>
801016c8:	eb 2b                	jmp    801016f5 <ialloc+0xd3>
    }
    brelse(bp);
801016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016cd:	89 04 24             	mov    %eax,(%esp)
801016d0:	e8 42 eb ff ff       	call   80100217 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016dc:	a1 48 12 11 80       	mov    0x80111248,%eax
801016e1:	39 c2                	cmp    %eax,%edx
801016e3:	0f 82 52 ff ff ff    	jb     8010163b <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016e9:	c7 04 24 ab 85 10 80 	movl   $0x801085ab,(%esp)
801016f0:	e8 45 ee ff ff       	call   8010053a <panic>
}
801016f5:	c9                   	leave  
801016f6:	c3                   	ret    

801016f7 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016f7:	55                   	push   %ebp
801016f8:	89 e5                	mov    %esp,%ebp
801016fa:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	8b 40 04             	mov    0x4(%eax),%eax
80101703:	c1 e8 03             	shr    $0x3,%eax
80101706:	89 c2                	mov    %eax,%edx
80101708:	a1 54 12 11 80       	mov    0x80111254,%eax
8010170d:	01 c2                	add    %eax,%edx
8010170f:	8b 45 08             	mov    0x8(%ebp),%eax
80101712:	8b 00                	mov    (%eax),%eax
80101714:	89 54 24 04          	mov    %edx,0x4(%esp)
80101718:	89 04 24             	mov    %eax,(%esp)
8010171b:	e8 86 ea ff ff       	call   801001a6 <bread>
80101720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101726:	8d 50 18             	lea    0x18(%eax),%edx
80101729:	8b 45 08             	mov    0x8(%ebp),%eax
8010172c:	8b 40 04             	mov    0x4(%eax),%eax
8010172f:	83 e0 07             	and    $0x7,%eax
80101732:	c1 e0 06             	shl    $0x6,%eax
80101735:	01 d0                	add    %edx,%eax
80101737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010173a:	8b 45 08             	mov    0x8(%ebp),%eax
8010173d:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101747:	8b 45 08             	mov    0x8(%ebp),%eax
8010174a:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101751:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101755:	8b 45 08             	mov    0x8(%ebp),%eax
80101758:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101763:	8b 45 08             	mov    0x8(%ebp),%eax
80101766:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176d:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101771:	8b 45 08             	mov    0x8(%ebp),%eax
80101774:	8b 50 18             	mov    0x18(%eax),%edx
80101777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177a:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	8b 45 08             	mov    0x8(%ebp),%eax
80101780:	8d 50 1c             	lea    0x1c(%eax),%edx
80101783:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101786:	83 c0 0c             	add    $0xc,%eax
80101789:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101790:	00 
80101791:	89 54 24 04          	mov    %edx,0x4(%esp)
80101795:	89 04 24             	mov    %eax,(%esp)
80101798:	e8 23 3a 00 00       	call   801051c0 <memmove>
  log_write(bp);
8010179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a0:	89 04 24             	mov    %eax,(%esp)
801017a3:	e8 04 1f 00 00       	call   801036ac <log_write>
  brelse(bp);
801017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ab:	89 04 24             	mov    %eax,(%esp)
801017ae:	e8 64 ea ff ff       	call   80100217 <brelse>
}
801017b3:	c9                   	leave  
801017b4:	c3                   	ret    

801017b5 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017b5:	55                   	push   %ebp
801017b6:	89 e5                	mov    %esp,%ebp
801017b8:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017bb:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801017c2:	e8 cc 36 00 00       	call   80104e93 <acquire>

  // Is the inode already cached?
  empty = 0;
801017c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ce:	c7 45 f4 94 12 11 80 	movl   $0x80111294,-0xc(%ebp)
801017d5:	eb 59                	jmp    80101830 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017da:	8b 40 08             	mov    0x8(%eax),%eax
801017dd:	85 c0                	test   %eax,%eax
801017df:	7e 35                	jle    80101816 <iget+0x61>
801017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e4:	8b 00                	mov    (%eax),%eax
801017e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801017e9:	75 2b                	jne    80101816 <iget+0x61>
801017eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ee:	8b 40 04             	mov    0x4(%eax),%eax
801017f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017f4:	75 20                	jne    80101816 <iget+0x61>
      ip->ref++;
801017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f9:	8b 40 08             	mov    0x8(%eax),%eax
801017fc:	8d 50 01             	lea    0x1(%eax),%edx
801017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101802:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101805:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
8010180c:	e8 e4 36 00 00       	call   80104ef5 <release>
      return ip;
80101811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101814:	eb 6f                	jmp    80101885 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010181a:	75 10                	jne    8010182c <iget+0x77>
8010181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181f:	8b 40 08             	mov    0x8(%eax),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	75 06                	jne    8010182c <iget+0x77>
      empty = ip;
80101826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101829:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182c:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101830:	81 7d f4 34 22 11 80 	cmpl   $0x80112234,-0xc(%ebp)
80101837:	72 9e                	jb     801017d7 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010183d:	75 0c                	jne    8010184b <iget+0x96>
    panic("iget: no inodes");
8010183f:	c7 04 24 bd 85 10 80 	movl   $0x801085bd,(%esp)
80101846:	e8 ef ec ff ff       	call   8010053a <panic>

  ip = empty;
8010184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101854:	8b 55 08             	mov    0x8(%ebp),%edx
80101857:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010185f:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101865:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101876:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
8010187d:	e8 73 36 00 00       	call   80104ef5 <release>

  return ip;
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101885:	c9                   	leave  
80101886:	c3                   	ret    

80101887 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101887:	55                   	push   %ebp
80101888:	89 e5                	mov    %esp,%ebp
8010188a:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010188d:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101894:	e8 fa 35 00 00       	call   80104e93 <acquire>
  ip->ref++;
80101899:	8b 45 08             	mov    0x8(%ebp),%eax
8010189c:	8b 40 08             	mov    0x8(%eax),%eax
8010189f:	8d 50 01             	lea    0x1(%eax),%edx
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018a8:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801018af:	e8 41 36 00 00       	call   80104ef5 <release>
  return ip;
801018b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018b7:	c9                   	leave  
801018b8:	c3                   	ret    

801018b9 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018b9:	55                   	push   %ebp
801018ba:	89 e5                	mov    %esp,%ebp
801018bc:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018c3:	74 0a                	je     801018cf <ilock+0x16>
801018c5:	8b 45 08             	mov    0x8(%ebp),%eax
801018c8:	8b 40 08             	mov    0x8(%eax),%eax
801018cb:	85 c0                	test   %eax,%eax
801018cd:	7f 0c                	jg     801018db <ilock+0x22>
    panic("ilock");
801018cf:	c7 04 24 cd 85 10 80 	movl   $0x801085cd,(%esp)
801018d6:	e8 5f ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018db:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801018e2:	e8 ac 35 00 00       	call   80104e93 <acquire>
  while(ip->flags & I_BUSY)
801018e7:	eb 13                	jmp    801018fc <ilock+0x43>
    sleep(ip, &icache.lock);
801018e9:	c7 44 24 04 60 12 11 	movl   $0x80111260,0x4(%esp)
801018f0:	80 
801018f1:	8b 45 08             	mov    0x8(%ebp),%eax
801018f4:	89 04 24             	mov    %eax,(%esp)
801018f7:	e8 c3 32 00 00       	call   80104bbf <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	8b 40 0c             	mov    0xc(%eax),%eax
80101902:	83 e0 01             	and    $0x1,%eax
80101905:	85 c0                	test   %eax,%eax
80101907:	75 e0                	jne    801018e9 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	8b 40 0c             	mov    0xc(%eax),%eax
8010190f:	83 c8 01             	or     $0x1,%eax
80101912:	89 c2                	mov    %eax,%edx
80101914:	8b 45 08             	mov    0x8(%ebp),%eax
80101917:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010191a:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101921:	e8 cf 35 00 00       	call   80104ef5 <release>

  if(!(ip->flags & I_VALID)){
80101926:	8b 45 08             	mov    0x8(%ebp),%eax
80101929:	8b 40 0c             	mov    0xc(%eax),%eax
8010192c:	83 e0 02             	and    $0x2,%eax
8010192f:	85 c0                	test   %eax,%eax
80101931:	0f 85 d4 00 00 00    	jne    80101a0b <ilock+0x152>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101937:	8b 45 08             	mov    0x8(%ebp),%eax
8010193a:	8b 40 04             	mov    0x4(%eax),%eax
8010193d:	c1 e8 03             	shr    $0x3,%eax
80101940:	89 c2                	mov    %eax,%edx
80101942:	a1 54 12 11 80       	mov    0x80111254,%eax
80101947:	01 c2                	add    %eax,%edx
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 00                	mov    (%eax),%eax
8010194e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101952:	89 04 24             	mov    %eax,(%esp)
80101955:	e8 4c e8 ff ff       	call   801001a6 <bread>
8010195a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101960:	8d 50 18             	lea    0x18(%eax),%edx
80101963:	8b 45 08             	mov    0x8(%ebp),%eax
80101966:	8b 40 04             	mov    0x4(%eax),%eax
80101969:	83 e0 07             	and    $0x7,%eax
8010196c:	c1 e0 06             	shl    $0x6,%eax
8010196f:	01 d0                	add    %edx,%eax
80101971:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101977:	0f b7 10             	movzwl (%eax),%edx
8010197a:	8b 45 08             	mov    0x8(%ebp),%eax
8010197d:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101984:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101992:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010199d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a0:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019a4:	8b 45 08             	mov    0x8(%ebp),%eax
801019a7:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ae:	8b 50 08             	mov    0x8(%eax),%edx
801019b1:	8b 45 08             	mov    0x8(%ebp),%eax
801019b4:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ba:	8d 50 0c             	lea    0xc(%eax),%edx
801019bd:	8b 45 08             	mov    0x8(%ebp),%eax
801019c0:	83 c0 1c             	add    $0x1c,%eax
801019c3:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019ca:	00 
801019cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801019cf:	89 04 24             	mov    %eax,(%esp)
801019d2:	e8 e9 37 00 00       	call   801051c0 <memmove>
    brelse(bp);
801019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019da:	89 04 24             	mov    %eax,(%esp)
801019dd:	e8 35 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	8b 40 0c             	mov    0xc(%eax),%eax
801019e8:	83 c8 02             	or     $0x2,%eax
801019eb:	89 c2                	mov    %eax,%edx
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019f3:	8b 45 08             	mov    0x8(%ebp),%eax
801019f6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019fa:	66 85 c0             	test   %ax,%ax
801019fd:	75 0c                	jne    80101a0b <ilock+0x152>
      panic("ilock: no type");
801019ff:	c7 04 24 d3 85 10 80 	movl   $0x801085d3,(%esp)
80101a06:	e8 2f eb ff ff       	call   8010053a <panic>
  }
}
80101a0b:	c9                   	leave  
80101a0c:	c3                   	ret    

80101a0d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a0d:	55                   	push   %ebp
80101a0e:	89 e5                	mov    %esp,%ebp
80101a10:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a17:	74 17                	je     80101a30 <iunlock+0x23>
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a1f:	83 e0 01             	and    $0x1,%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	74 0a                	je     80101a30 <iunlock+0x23>
80101a26:	8b 45 08             	mov    0x8(%ebp),%eax
80101a29:	8b 40 08             	mov    0x8(%eax),%eax
80101a2c:	85 c0                	test   %eax,%eax
80101a2e:	7f 0c                	jg     80101a3c <iunlock+0x2f>
    panic("iunlock");
80101a30:	c7 04 24 e2 85 10 80 	movl   $0x801085e2,(%esp)
80101a37:	e8 fe ea ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a3c:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a43:	e8 4b 34 00 00       	call   80104e93 <acquire>
  ip->flags &= ~I_BUSY;
80101a48:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a4e:	83 e0 fe             	and    $0xfffffffe,%eax
80101a51:	89 c2                	mov    %eax,%edx
80101a53:	8b 45 08             	mov    0x8(%ebp),%eax
80101a56:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	89 04 24             	mov    %eax,(%esp)
80101a5f:	e8 34 32 00 00       	call   80104c98 <wakeup>
  release(&icache.lock);
80101a64:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a6b:	e8 85 34 00 00       	call   80104ef5 <release>
}
80101a70:	c9                   	leave  
80101a71:	c3                   	ret    

80101a72 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a72:	55                   	push   %ebp
80101a73:	89 e5                	mov    %esp,%ebp
80101a75:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a78:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a7f:	e8 0f 34 00 00       	call   80104e93 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a84:	8b 45 08             	mov    0x8(%ebp),%eax
80101a87:	8b 40 08             	mov    0x8(%eax),%eax
80101a8a:	83 f8 01             	cmp    $0x1,%eax
80101a8d:	0f 85 93 00 00 00    	jne    80101b26 <iput+0xb4>
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	8b 40 0c             	mov    0xc(%eax),%eax
80101a99:	83 e0 02             	and    $0x2,%eax
80101a9c:	85 c0                	test   %eax,%eax
80101a9e:	0f 84 82 00 00 00    	je     80101b26 <iput+0xb4>
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101aab:	66 85 c0             	test   %ax,%ax
80101aae:	75 76                	jne    80101b26 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab6:	83 e0 01             	and    $0x1,%eax
80101ab9:	85 c0                	test   %eax,%eax
80101abb:	74 0c                	je     80101ac9 <iput+0x57>
      panic("iput busy");
80101abd:	c7 04 24 ea 85 10 80 	movl   $0x801085ea,(%esp)
80101ac4:	e8 71 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	8b 40 0c             	mov    0xc(%eax),%eax
80101acf:	83 c8 01             	or     $0x1,%eax
80101ad2:	89 c2                	mov    %eax,%edx
80101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad7:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ada:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101ae1:	e8 0f 34 00 00       	call   80104ef5 <release>
    itrunc(ip);
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	89 04 24             	mov    %eax,(%esp)
80101aec:	e8 7d 01 00 00       	call   80101c6e <itrunc>
    ip->type = 0;
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101afa:	8b 45 08             	mov    0x8(%ebp),%eax
80101afd:	89 04 24             	mov    %eax,(%esp)
80101b00:	e8 f2 fb ff ff       	call   801016f7 <iupdate>
    acquire(&icache.lock);
80101b05:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101b0c:	e8 82 33 00 00       	call   80104e93 <acquire>
    ip->flags = 0;
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	89 04 24             	mov    %eax,(%esp)
80101b21:	e8 72 31 00 00       	call   80104c98 <wakeup>
  }
  ip->ref--;
80101b26:	8b 45 08             	mov    0x8(%ebp),%eax
80101b29:	8b 40 08             	mov    0x8(%eax),%eax
80101b2c:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b32:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b35:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101b3c:	e8 b4 33 00 00       	call   80104ef5 <release>
}
80101b41:	c9                   	leave  
80101b42:	c3                   	ret    

80101b43 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b43:	55                   	push   %ebp
80101b44:	89 e5                	mov    %esp,%ebp
80101b46:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	89 04 24             	mov    %eax,(%esp)
80101b4f:	e8 b9 fe ff ff       	call   80101a0d <iunlock>
  iput(ip);
80101b54:	8b 45 08             	mov    0x8(%ebp),%eax
80101b57:	89 04 24             	mov    %eax,(%esp)
80101b5a:	e8 13 ff ff ff       	call   80101a72 <iput>
}
80101b5f:	c9                   	leave  
80101b60:	c3                   	ret    

80101b61 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	53                   	push   %ebx
80101b65:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b68:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b6c:	77 3e                	ja     80101bac <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b74:	83 c2 04             	add    $0x4,%edx
80101b77:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b82:	75 20                	jne    80101ba4 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b84:	8b 45 08             	mov    0x8(%ebp),%eax
80101b87:	8b 00                	mov    (%eax),%eax
80101b89:	89 04 24             	mov    %eax,(%esp)
80101b8c:	e8 f7 f7 ff ff       	call   80101388 <balloc>
80101b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b94:	8b 45 08             	mov    0x8(%ebp),%eax
80101b97:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b9a:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ba0:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba7:	e9 bc 00 00 00       	jmp    80101c68 <bmap+0x107>
  }
  bn -= NDIRECT;
80101bac:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bb0:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bb4:	0f 87 a2 00 00 00    	ja     80101c5c <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bba:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbd:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc7:	75 19                	jne    80101be2 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	8b 00                	mov    (%eax),%eax
80101bce:	89 04 24             	mov    %eax,(%esp)
80101bd1:	e8 b2 f7 ff ff       	call   80101388 <balloc>
80101bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bdf:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	8b 00                	mov    (%eax),%eax
80101be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bea:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bee:	89 04 24             	mov    %eax,(%esp)
80101bf1:	e8 b0 e5 ff ff       	call   801001a6 <bread>
80101bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfc:	83 c0 18             	add    $0x18,%eax
80101bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c02:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c0f:	01 d0                	add    %edx,%eax
80101c11:	8b 00                	mov    (%eax),%eax
80101c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c1a:	75 30                	jne    80101c4c <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c29:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2f:	8b 00                	mov    (%eax),%eax
80101c31:	89 04 24             	mov    %eax,(%esp)
80101c34:	e8 4f f7 ff ff       	call   80101388 <balloc>
80101c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c3f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c44:	89 04 24             	mov    %eax,(%esp)
80101c47:	e8 60 1a 00 00       	call   801036ac <log_write>
    }
    brelse(bp);
80101c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c4f:	89 04 24             	mov    %eax,(%esp)
80101c52:	e8 c0 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c5a:	eb 0c                	jmp    80101c68 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c5c:	c7 04 24 f4 85 10 80 	movl   $0x801085f4,(%esp)
80101c63:	e8 d2 e8 ff ff       	call   8010053a <panic>
}
80101c68:	83 c4 24             	add    $0x24,%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5d                   	pop    %ebp
80101c6d:	c3                   	ret    

80101c6e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c6e:	55                   	push   %ebp
80101c6f:	89 e5                	mov    %esp,%ebp
80101c71:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c7b:	eb 44                	jmp    80101cc1 <itrunc+0x53>
    if(ip->addrs[i]){
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c83:	83 c2 04             	add    $0x4,%edx
80101c86:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c8a:	85 c0                	test   %eax,%eax
80101c8c:	74 2f                	je     80101cbd <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c94:	83 c2 04             	add    $0x4,%edx
80101c97:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9e:	8b 00                	mov    (%eax),%eax
80101ca0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ca4:	89 04 24             	mov    %eax,(%esp)
80101ca7:	e8 1a f8 ff ff       	call   801014c6 <bfree>
      ip->addrs[i] = 0;
80101cac:	8b 45 08             	mov    0x8(%ebp),%eax
80101caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb2:	83 c2 04             	add    $0x4,%edx
80101cb5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cbc:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101cc1:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cc5:	7e b6                	jle    80101c7d <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cca:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ccd:	85 c0                	test   %eax,%eax
80101ccf:	0f 84 9b 00 00 00    	je     80101d70 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	8b 00                	mov    (%eax),%eax
80101ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce4:	89 04 24             	mov    %eax,(%esp)
80101ce7:	e8 ba e4 ff ff       	call   801001a6 <bread>
80101cec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf2:	83 c0 18             	add    $0x18,%eax
80101cf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cf8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cff:	eb 3b                	jmp    80101d3c <itrunc+0xce>
      if(a[j])
80101d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d0e:	01 d0                	add    %edx,%eax
80101d10:	8b 00                	mov    (%eax),%eax
80101d12:	85 c0                	test   %eax,%eax
80101d14:	74 22                	je     80101d38 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d23:	01 d0                	add    %edx,%eax
80101d25:	8b 10                	mov    (%eax),%edx
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	8b 00                	mov    (%eax),%eax
80101d2c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d30:	89 04 24             	mov    %eax,(%esp)
80101d33:	e8 8e f7 ff ff       	call   801014c6 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d38:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d3f:	83 f8 7f             	cmp    $0x7f,%eax
80101d42:	76 bd                	jbe    80101d01 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d47:	89 04 24             	mov    %eax,(%esp)
80101d4a:	e8 c8 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d55:	8b 45 08             	mov    0x8(%ebp),%eax
80101d58:	8b 00                	mov    (%eax),%eax
80101d5a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d5e:	89 04 24             	mov    %eax,(%esp)
80101d61:	e8 60 f7 ff ff       	call   801014c6 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d66:	8b 45 08             	mov    0x8(%ebp),%eax
80101d69:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d70:	8b 45 08             	mov    0x8(%ebp),%eax
80101d73:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7d:	89 04 24             	mov    %eax,(%esp)
80101d80:	e8 72 f9 ff ff       	call   801016f7 <iupdate>
}
80101d85:	c9                   	leave  
80101d86:	c3                   	ret    

80101d87 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d87:	55                   	push   %ebp
80101d88:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8d:	8b 00                	mov    (%eax),%eax
80101d8f:	89 c2                	mov    %eax,%edx
80101d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d94:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d97:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9a:	8b 50 04             	mov    0x4(%eax),%edx
80101d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da0:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101da3:	8b 45 08             	mov    0x8(%ebp),%eax
80101da6:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101daa:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dad:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101db0:	8b 45 08             	mov    0x8(%ebp),%eax
80101db3:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dba:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 50 18             	mov    0x18(%eax),%edx
80101dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc7:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dca:	5d                   	pop    %ebp
80101dcb:	c3                   	ret    

80101dcc <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dcc:	55                   	push   %ebp
80101dcd:	89 e5                	mov    %esp,%ebp
80101dcf:	83 ec 28             	sub    $0x28,%esp
  
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101dd9:	66 83 f8 03          	cmp    $0x3,%ax
80101ddd:	75 60                	jne    80101e3f <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80101de2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101de6:	66 85 c0             	test   %ax,%ax
80101de9:	78 20                	js     80101e0b <readi+0x3f>
80101deb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101df2:	66 83 f8 09          	cmp    $0x9,%ax
80101df6:	7f 13                	jg     80101e0b <readi+0x3f>
80101df8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dff:	98                   	cwtl   
80101e00:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101e07:	85 c0                	test   %eax,%eax
80101e09:	75 0a                	jne    80101e15 <readi+0x49>
      return -1;
80101e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e10:	e9 19 01 00 00       	jmp    80101f2e <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e15:	8b 45 08             	mov    0x8(%ebp),%eax
80101e18:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e1c:	98                   	cwtl   
80101e1d:	8b 04 c5 e0 11 11 80 	mov    -0x7feeee20(,%eax,8),%eax
80101e24:	8b 55 14             	mov    0x14(%ebp),%edx
80101e27:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e2e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e32:	8b 55 08             	mov    0x8(%ebp),%edx
80101e35:	89 14 24             	mov    %edx,(%esp)
80101e38:	ff d0                	call   *%eax
80101e3a:	e9 ef 00 00 00       	jmp    80101f2e <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 40 18             	mov    0x18(%eax),%eax
80101e45:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e48:	72 0d                	jb     80101e57 <readi+0x8b>
80101e4a:	8b 45 14             	mov    0x14(%ebp),%eax
80101e4d:	8b 55 10             	mov    0x10(%ebp),%edx
80101e50:	01 d0                	add    %edx,%eax
80101e52:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e55:	73 0a                	jae    80101e61 <readi+0x95>
    return -1;
80101e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e5c:	e9 cd 00 00 00       	jmp    80101f2e <readi+0x162>
  if(off + n > ip->size)
80101e61:	8b 45 14             	mov    0x14(%ebp),%eax
80101e64:	8b 55 10             	mov    0x10(%ebp),%edx
80101e67:	01 c2                	add    %eax,%edx
80101e69:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6c:	8b 40 18             	mov    0x18(%eax),%eax
80101e6f:	39 c2                	cmp    %eax,%edx
80101e71:	76 0c                	jbe    80101e7f <readi+0xb3>
    n = ip->size - off;
80101e73:	8b 45 08             	mov    0x8(%ebp),%eax
80101e76:	8b 40 18             	mov    0x18(%eax),%eax
80101e79:	2b 45 10             	sub    0x10(%ebp),%eax
80101e7c:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e86:	e9 94 00 00 00       	jmp    80101f1f <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e8b:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8e:	c1 e8 09             	shr    $0x9,%eax
80101e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e95:	8b 45 08             	mov    0x8(%ebp),%eax
80101e98:	89 04 24             	mov    %eax,(%esp)
80101e9b:	e8 c1 fc ff ff       	call   80101b61 <bmap>
80101ea0:	8b 55 08             	mov    0x8(%ebp),%edx
80101ea3:	8b 12                	mov    (%edx),%edx
80101ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ea9:	89 14 24             	mov    %edx,(%esp)
80101eac:	e8 f5 e2 ff ff       	call   801001a6 <bread>
80101eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb4:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ebc:	89 c2                	mov    %eax,%edx
80101ebe:	b8 00 02 00 00       	mov    $0x200,%eax
80101ec3:	29 d0                	sub    %edx,%eax
80101ec5:	89 c2                	mov    %eax,%edx
80101ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eca:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ecd:	29 c1                	sub    %eax,%ecx
80101ecf:	89 c8                	mov    %ecx,%eax
80101ed1:	39 c2                	cmp    %eax,%edx
80101ed3:	0f 46 c2             	cmovbe %edx,%eax
80101ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ed9:	8b 45 10             	mov    0x10(%ebp),%eax
80101edc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ee1:	8d 50 10             	lea    0x10(%eax),%edx
80101ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee7:	01 d0                	add    %edx,%eax
80101ee9:	8d 50 08             	lea    0x8(%eax),%edx
80101eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eef:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ef3:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101efa:	89 04 24             	mov    %eax,(%esp)
80101efd:	e8 be 32 00 00       	call   801051c0 <memmove>
    brelse(bp);
80101f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f05:	89 04 24             	mov    %eax,(%esp)
80101f08:	e8 0a e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f10:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f16:	01 45 10             	add    %eax,0x10(%ebp)
80101f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1c:	01 45 0c             	add    %eax,0xc(%ebp)
80101f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f22:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f25:	0f 82 60 ff ff ff    	jb     80101e8b <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f2b:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f2e:	c9                   	leave  
80101f2f:	c3                   	ret    

80101f30 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f36:	8b 45 08             	mov    0x8(%ebp),%eax
80101f39:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f3d:	66 83 f8 03          	cmp    $0x3,%ax
80101f41:	75 60                	jne    80101fa3 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f43:	8b 45 08             	mov    0x8(%ebp),%eax
80101f46:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4a:	66 85 c0             	test   %ax,%ax
80101f4d:	78 20                	js     80101f6f <writei+0x3f>
80101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f52:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f56:	66 83 f8 09          	cmp    $0x9,%ax
80101f5a:	7f 13                	jg     80101f6f <writei+0x3f>
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f63:	98                   	cwtl   
80101f64:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f6b:	85 c0                	test   %eax,%eax
80101f6d:	75 0a                	jne    80101f79 <writei+0x49>
      return -1;
80101f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f74:	e9 44 01 00 00       	jmp    801020bd <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f80:	98                   	cwtl   
80101f81:	8b 04 c5 e4 11 11 80 	mov    -0x7feeee1c(,%eax,8),%eax
80101f88:	8b 55 14             	mov    0x14(%ebp),%edx
80101f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f92:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f96:	8b 55 08             	mov    0x8(%ebp),%edx
80101f99:	89 14 24             	mov    %edx,(%esp)
80101f9c:	ff d0                	call   *%eax
80101f9e:	e9 1a 01 00 00       	jmp    801020bd <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa6:	8b 40 18             	mov    0x18(%eax),%eax
80101fa9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fac:	72 0d                	jb     80101fbb <writei+0x8b>
80101fae:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb1:	8b 55 10             	mov    0x10(%ebp),%edx
80101fb4:	01 d0                	add    %edx,%eax
80101fb6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fb9:	73 0a                	jae    80101fc5 <writei+0x95>
    return -1;
80101fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc0:	e9 f8 00 00 00       	jmp    801020bd <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc8:	8b 55 10             	mov    0x10(%ebp),%edx
80101fcb:	01 d0                	add    %edx,%eax
80101fcd:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fd2:	76 0a                	jbe    80101fde <writei+0xae>
    return -1;
80101fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd9:	e9 df 00 00 00       	jmp    801020bd <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fe5:	e9 9f 00 00 00       	jmp    80102089 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fea:	8b 45 10             	mov    0x10(%ebp),%eax
80101fed:	c1 e8 09             	shr    $0x9,%eax
80101ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff7:	89 04 24             	mov    %eax,(%esp)
80101ffa:	e8 62 fb ff ff       	call   80101b61 <bmap>
80101fff:	8b 55 08             	mov    0x8(%ebp),%edx
80102002:	8b 12                	mov    (%edx),%edx
80102004:	89 44 24 04          	mov    %eax,0x4(%esp)
80102008:	89 14 24             	mov    %edx,(%esp)
8010200b:	e8 96 e1 ff ff       	call   801001a6 <bread>
80102010:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102013:	8b 45 10             	mov    0x10(%ebp),%eax
80102016:	25 ff 01 00 00       	and    $0x1ff,%eax
8010201b:	89 c2                	mov    %eax,%edx
8010201d:	b8 00 02 00 00       	mov    $0x200,%eax
80102022:	29 d0                	sub    %edx,%eax
80102024:	89 c2                	mov    %eax,%edx
80102026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102029:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010202c:	29 c1                	sub    %eax,%ecx
8010202e:	89 c8                	mov    %ecx,%eax
80102030:	39 c2                	cmp    %eax,%edx
80102032:	0f 46 c2             	cmovbe %edx,%eax
80102035:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102038:	8b 45 10             	mov    0x10(%ebp),%eax
8010203b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102040:	8d 50 10             	lea    0x10(%eax),%edx
80102043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102046:	01 d0                	add    %edx,%eax
80102048:	8d 50 08             	lea    0x8(%eax),%edx
8010204b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010204e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102052:	8b 45 0c             	mov    0xc(%ebp),%eax
80102055:	89 44 24 04          	mov    %eax,0x4(%esp)
80102059:	89 14 24             	mov    %edx,(%esp)
8010205c:	e8 5f 31 00 00       	call   801051c0 <memmove>
    log_write(bp);
80102061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102064:	89 04 24             	mov    %eax,(%esp)
80102067:	e8 40 16 00 00       	call   801036ac <log_write>
    brelse(bp);
8010206c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010206f:	89 04 24             	mov    %eax,(%esp)
80102072:	e8 a0 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102077:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207a:	01 45 f4             	add    %eax,-0xc(%ebp)
8010207d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102080:	01 45 10             	add    %eax,0x10(%ebp)
80102083:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102086:	01 45 0c             	add    %eax,0xc(%ebp)
80102089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010208c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010208f:	0f 82 55 ff ff ff    	jb     80101fea <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102095:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102099:	74 1f                	je     801020ba <writei+0x18a>
8010209b:	8b 45 08             	mov    0x8(%ebp),%eax
8010209e:	8b 40 18             	mov    0x18(%eax),%eax
801020a1:	3b 45 10             	cmp    0x10(%ebp),%eax
801020a4:	73 14                	jae    801020ba <writei+0x18a>
    ip->size = off;
801020a6:	8b 45 08             	mov    0x8(%ebp),%eax
801020a9:	8b 55 10             	mov    0x10(%ebp),%edx
801020ac:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020af:	8b 45 08             	mov    0x8(%ebp),%eax
801020b2:	89 04 24             	mov    %eax,(%esp)
801020b5:	e8 3d f6 ff ff       	call   801016f7 <iupdate>
  }
  return n;
801020ba:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020bd:	c9                   	leave  
801020be:	c3                   	ret    

801020bf <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020bf:	55                   	push   %ebp
801020c0:	89 e5                	mov    %esp,%ebp
801020c2:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020c5:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020cc:	00 
801020cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801020d4:	8b 45 08             	mov    0x8(%ebp),%eax
801020d7:	89 04 24             	mov    %eax,(%esp)
801020da:	e8 84 31 00 00       	call   80105263 <strncmp>
}
801020df:	c9                   	leave  
801020e0:	c3                   	ret    

801020e1 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020e1:	55                   	push   %ebp
801020e2:	89 e5                	mov    %esp,%ebp
801020e4:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020ee:	66 83 f8 01          	cmp    $0x1,%ax
801020f2:	74 0c                	je     80102100 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020f4:	c7 04 24 07 86 10 80 	movl   $0x80108607,(%esp)
801020fb:	e8 3a e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102107:	e9 88 00 00 00       	jmp    80102194 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010210c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102113:	00 
80102114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102117:	89 44 24 08          	mov    %eax,0x8(%esp)
8010211b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010211e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102122:	8b 45 08             	mov    0x8(%ebp),%eax
80102125:	89 04 24             	mov    %eax,(%esp)
80102128:	e8 9f fc ff ff       	call   80101dcc <readi>
8010212d:	83 f8 10             	cmp    $0x10,%eax
80102130:	74 0c                	je     8010213e <dirlookup+0x5d>
      panic("dirlink read");
80102132:	c7 04 24 19 86 10 80 	movl   $0x80108619,(%esp)
80102139:	e8 fc e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
8010213e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102142:	66 85 c0             	test   %ax,%ax
80102145:	75 02                	jne    80102149 <dirlookup+0x68>
      continue;
80102147:	eb 47                	jmp    80102190 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102149:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010214c:	83 c0 02             	add    $0x2,%eax
8010214f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102153:	8b 45 0c             	mov    0xc(%ebp),%eax
80102156:	89 04 24             	mov    %eax,(%esp)
80102159:	e8 61 ff ff ff       	call   801020bf <namecmp>
8010215e:	85 c0                	test   %eax,%eax
80102160:	75 2e                	jne    80102190 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102162:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102166:	74 08                	je     80102170 <dirlookup+0x8f>
        *poff = off;
80102168:	8b 45 10             	mov    0x10(%ebp),%eax
8010216b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010216e:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102170:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102174:	0f b7 c0             	movzwl %ax,%eax
80102177:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010217a:	8b 45 08             	mov    0x8(%ebp),%eax
8010217d:	8b 00                	mov    (%eax),%eax
8010217f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102182:	89 54 24 04          	mov    %edx,0x4(%esp)
80102186:	89 04 24             	mov    %eax,(%esp)
80102189:	e8 27 f6 ff ff       	call   801017b5 <iget>
8010218e:	eb 18                	jmp    801021a8 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102190:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102194:	8b 45 08             	mov    0x8(%ebp),%eax
80102197:	8b 40 18             	mov    0x18(%eax),%eax
8010219a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010219d:	0f 87 69 ff ff ff    	ja     8010210c <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021a8:	c9                   	leave  
801021a9:	c3                   	ret    

801021aa <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021aa:	55                   	push   %ebp
801021ab:	89 e5                	mov    %esp,%ebp
801021ad:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021b7:	00 
801021b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801021bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801021bf:	8b 45 08             	mov    0x8(%ebp),%eax
801021c2:	89 04 24             	mov    %eax,(%esp)
801021c5:	e8 17 ff ff ff       	call   801020e1 <dirlookup>
801021ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021d1:	74 15                	je     801021e8 <dirlink+0x3e>
    iput(ip);
801021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021d6:	89 04 24             	mov    %eax,(%esp)
801021d9:	e8 94 f8 ff ff       	call   80101a72 <iput>
    return -1;
801021de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e3:	e9 b7 00 00 00       	jmp    8010229f <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ef:	eb 46                	jmp    80102237 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021f4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021fb:	00 
801021fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80102200:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102203:	89 44 24 04          	mov    %eax,0x4(%esp)
80102207:	8b 45 08             	mov    0x8(%ebp),%eax
8010220a:	89 04 24             	mov    %eax,(%esp)
8010220d:	e8 ba fb ff ff       	call   80101dcc <readi>
80102212:	83 f8 10             	cmp    $0x10,%eax
80102215:	74 0c                	je     80102223 <dirlink+0x79>
      panic("dirlink read");
80102217:	c7 04 24 19 86 10 80 	movl   $0x80108619,(%esp)
8010221e:	e8 17 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102223:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102227:	66 85 c0             	test   %ax,%ax
8010222a:	75 02                	jne    8010222e <dirlink+0x84>
      break;
8010222c:	eb 16                	jmp    80102244 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102231:	83 c0 10             	add    $0x10,%eax
80102234:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102237:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010223a:	8b 45 08             	mov    0x8(%ebp),%eax
8010223d:	8b 40 18             	mov    0x18(%eax),%eax
80102240:	39 c2                	cmp    %eax,%edx
80102242:	72 ad                	jb     801021f1 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102244:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010224b:	00 
8010224c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010224f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102253:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102256:	83 c0 02             	add    $0x2,%eax
80102259:	89 04 24             	mov    %eax,(%esp)
8010225c:	e8 58 30 00 00       	call   801052b9 <strncpy>
  de.inum = inum;
80102261:	8b 45 10             	mov    0x10(%ebp),%eax
80102264:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010226b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102272:	00 
80102273:	89 44 24 08          	mov    %eax,0x8(%esp)
80102277:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010227e:	8b 45 08             	mov    0x8(%ebp),%eax
80102281:	89 04 24             	mov    %eax,(%esp)
80102284:	e8 a7 fc ff ff       	call   80101f30 <writei>
80102289:	83 f8 10             	cmp    $0x10,%eax
8010228c:	74 0c                	je     8010229a <dirlink+0xf0>
    panic("dirlink");
8010228e:	c7 04 24 26 86 10 80 	movl   $0x80108626,(%esp)
80102295:	e8 a0 e2 ff ff       	call   8010053a <panic>
  
  return 0;
8010229a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010229f:	c9                   	leave  
801022a0:	c3                   	ret    

801022a1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022a1:	55                   	push   %ebp
801022a2:	89 e5                	mov    %esp,%ebp
801022a4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022a7:	eb 04                	jmp    801022ad <skipelem+0xc>
    path++;
801022a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022ad:	8b 45 08             	mov    0x8(%ebp),%eax
801022b0:	0f b6 00             	movzbl (%eax),%eax
801022b3:	3c 2f                	cmp    $0x2f,%al
801022b5:	74 f2                	je     801022a9 <skipelem+0x8>
    path++;
  if(*path == 0)
801022b7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ba:	0f b6 00             	movzbl (%eax),%eax
801022bd:	84 c0                	test   %al,%al
801022bf:	75 0a                	jne    801022cb <skipelem+0x2a>
    return 0;
801022c1:	b8 00 00 00 00       	mov    $0x0,%eax
801022c6:	e9 86 00 00 00       	jmp    80102351 <skipelem+0xb0>
  s = path;
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
801022ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022d1:	eb 04                	jmp    801022d7 <skipelem+0x36>
    path++;
801022d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022d7:	8b 45 08             	mov    0x8(%ebp),%eax
801022da:	0f b6 00             	movzbl (%eax),%eax
801022dd:	3c 2f                	cmp    $0x2f,%al
801022df:	74 0a                	je     801022eb <skipelem+0x4a>
801022e1:	8b 45 08             	mov    0x8(%ebp),%eax
801022e4:	0f b6 00             	movzbl (%eax),%eax
801022e7:	84 c0                	test   %al,%al
801022e9:	75 e8                	jne    801022d3 <skipelem+0x32>
    path++;
  len = path - s;
801022eb:	8b 55 08             	mov    0x8(%ebp),%edx
801022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f1:	29 c2                	sub    %eax,%edx
801022f3:	89 d0                	mov    %edx,%eax
801022f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022f8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022fc:	7e 1c                	jle    8010231a <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022fe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102305:	00 
80102306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010230d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102310:	89 04 24             	mov    %eax,(%esp)
80102313:	e8 a8 2e 00 00       	call   801051c0 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102318:	eb 2a                	jmp    80102344 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010231d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102324:	89 44 24 04          	mov    %eax,0x4(%esp)
80102328:	8b 45 0c             	mov    0xc(%ebp),%eax
8010232b:	89 04 24             	mov    %eax,(%esp)
8010232e:	e8 8d 2e 00 00       	call   801051c0 <memmove>
    name[len] = 0;
80102333:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102336:	8b 45 0c             	mov    0xc(%ebp),%eax
80102339:	01 d0                	add    %edx,%eax
8010233b:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010233e:	eb 04                	jmp    80102344 <skipelem+0xa3>
    path++;
80102340:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102344:	8b 45 08             	mov    0x8(%ebp),%eax
80102347:	0f b6 00             	movzbl (%eax),%eax
8010234a:	3c 2f                	cmp    $0x2f,%al
8010234c:	74 f2                	je     80102340 <skipelem+0x9f>
    path++;
  return path;
8010234e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102351:	c9                   	leave  
80102352:	c3                   	ret    

80102353 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102353:	55                   	push   %ebp
80102354:	89 e5                	mov    %esp,%ebp
80102356:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102359:	8b 45 08             	mov    0x8(%ebp),%eax
8010235c:	0f b6 00             	movzbl (%eax),%eax
8010235f:	3c 2f                	cmp    $0x2f,%al
80102361:	75 1c                	jne    8010237f <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102363:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010236a:	00 
8010236b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102372:	e8 3e f4 ff ff       	call   801017b5 <iget>
80102377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010237a:	e9 af 00 00 00       	jmp    8010242e <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010237f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102385:	8b 40 68             	mov    0x68(%eax),%eax
80102388:	89 04 24             	mov    %eax,(%esp)
8010238b:	e8 f7 f4 ff ff       	call   80101887 <idup>
80102390:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102393:	e9 96 00 00 00       	jmp    8010242e <namex+0xdb>
    ilock(ip);
80102398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239b:	89 04 24             	mov    %eax,(%esp)
8010239e:	e8 16 f5 ff ff       	call   801018b9 <ilock>
    if(ip->type != T_DIR){
801023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023aa:	66 83 f8 01          	cmp    $0x1,%ax
801023ae:	74 15                	je     801023c5 <namex+0x72>
      iunlockput(ip);
801023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b3:	89 04 24             	mov    %eax,(%esp)
801023b6:	e8 88 f7 ff ff       	call   80101b43 <iunlockput>
      return 0;
801023bb:	b8 00 00 00 00       	mov    $0x0,%eax
801023c0:	e9 a3 00 00 00       	jmp    80102468 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023c9:	74 1d                	je     801023e8 <namex+0x95>
801023cb:	8b 45 08             	mov    0x8(%ebp),%eax
801023ce:	0f b6 00             	movzbl (%eax),%eax
801023d1:	84 c0                	test   %al,%al
801023d3:	75 13                	jne    801023e8 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d8:	89 04 24             	mov    %eax,(%esp)
801023db:	e8 2d f6 ff ff       	call   80101a0d <iunlock>
      return ip;
801023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e3:	e9 80 00 00 00       	jmp    80102468 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023ef:	00 
801023f0:	8b 45 10             	mov    0x10(%ebp),%eax
801023f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fa:	89 04 24             	mov    %eax,(%esp)
801023fd:	e8 df fc ff ff       	call   801020e1 <dirlookup>
80102402:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102409:	75 12                	jne    8010241d <namex+0xca>
      iunlockput(ip);
8010240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240e:	89 04 24             	mov    %eax,(%esp)
80102411:	e8 2d f7 ff ff       	call   80101b43 <iunlockput>
      return 0;
80102416:	b8 00 00 00 00       	mov    $0x0,%eax
8010241b:	eb 4b                	jmp    80102468 <namex+0x115>
    }
    iunlockput(ip);
8010241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102420:	89 04 24             	mov    %eax,(%esp)
80102423:	e8 1b f7 ff ff       	call   80101b43 <iunlockput>
    ip = next;
80102428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010242e:	8b 45 10             	mov    0x10(%ebp),%eax
80102431:	89 44 24 04          	mov    %eax,0x4(%esp)
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	89 04 24             	mov    %eax,(%esp)
8010243b:	e8 61 fe ff ff       	call   801022a1 <skipelem>
80102440:	89 45 08             	mov    %eax,0x8(%ebp)
80102443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102447:	0f 85 4b ff ff ff    	jne    80102398 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010244d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102451:	74 12                	je     80102465 <namex+0x112>
    iput(ip);
80102453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102456:	89 04 24             	mov    %eax,(%esp)
80102459:	e8 14 f6 ff ff       	call   80101a72 <iput>
    return 0;
8010245e:	b8 00 00 00 00       	mov    $0x0,%eax
80102463:	eb 03                	jmp    80102468 <namex+0x115>
  }
  return ip;
80102465:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102468:	c9                   	leave  
80102469:	c3                   	ret    

8010246a <namei>:

struct inode*
namei(char *path)
{
8010246a:	55                   	push   %ebp
8010246b:	89 e5                	mov    %esp,%ebp
8010246d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102470:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102473:	89 44 24 08          	mov    %eax,0x8(%esp)
80102477:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010247e:	00 
8010247f:	8b 45 08             	mov    0x8(%ebp),%eax
80102482:	89 04 24             	mov    %eax,(%esp)
80102485:	e8 c9 fe ff ff       	call   80102353 <namex>
}
8010248a:	c9                   	leave  
8010248b:	c3                   	ret    

8010248c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010248c:	55                   	push   %ebp
8010248d:	89 e5                	mov    %esp,%ebp
8010248f:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102492:	8b 45 0c             	mov    0xc(%ebp),%eax
80102495:	89 44 24 08          	mov    %eax,0x8(%esp)
80102499:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024a0:	00 
801024a1:	8b 45 08             	mov    0x8(%ebp),%eax
801024a4:	89 04 24             	mov    %eax,(%esp)
801024a7:	e8 a7 fe ff ff       	call   80102353 <namex>
}
801024ac:	c9                   	leave  
801024ad:	c3                   	ret    

801024ae <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024ae:	55                   	push   %ebp
801024af:	89 e5                	mov    %esp,%ebp
801024b1:	83 ec 14             	sub    $0x14,%esp
801024b4:	8b 45 08             	mov    0x8(%ebp),%eax
801024b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024bf:	89 c2                	mov    %eax,%edx
801024c1:	ec                   	in     (%dx),%al
801024c2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024c5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024c9:	c9                   	leave  
801024ca:	c3                   	ret    

801024cb <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024cb:	55                   	push   %ebp
801024cc:	89 e5                	mov    %esp,%ebp
801024ce:	57                   	push   %edi
801024cf:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024d0:	8b 55 08             	mov    0x8(%ebp),%edx
801024d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024d6:	8b 45 10             	mov    0x10(%ebp),%eax
801024d9:	89 cb                	mov    %ecx,%ebx
801024db:	89 df                	mov    %ebx,%edi
801024dd:	89 c1                	mov    %eax,%ecx
801024df:	fc                   	cld    
801024e0:	f3 6d                	rep insl (%dx),%es:(%edi)
801024e2:	89 c8                	mov    %ecx,%eax
801024e4:	89 fb                	mov    %edi,%ebx
801024e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024e9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024ec:	5b                   	pop    %ebx
801024ed:	5f                   	pop    %edi
801024ee:	5d                   	pop    %ebp
801024ef:	c3                   	ret    

801024f0 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	83 ec 08             	sub    $0x8,%esp
801024f6:	8b 55 08             	mov    0x8(%ebp),%edx
801024f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024fc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102500:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102503:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102507:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010250b:	ee                   	out    %al,(%dx)
}
8010250c:	c9                   	leave  
8010250d:	c3                   	ret    

8010250e <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010250e:	55                   	push   %ebp
8010250f:	89 e5                	mov    %esp,%ebp
80102511:	56                   	push   %esi
80102512:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102513:	8b 55 08             	mov    0x8(%ebp),%edx
80102516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102519:	8b 45 10             	mov    0x10(%ebp),%eax
8010251c:	89 cb                	mov    %ecx,%ebx
8010251e:	89 de                	mov    %ebx,%esi
80102520:	89 c1                	mov    %eax,%ecx
80102522:	fc                   	cld    
80102523:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102525:	89 c8                	mov    %ecx,%eax
80102527:	89 f3                	mov    %esi,%ebx
80102529:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010252c:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    

80102533 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102533:	55                   	push   %ebp
80102534:	89 e5                	mov    %esp,%ebp
80102536:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102539:	90                   	nop
8010253a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102541:	e8 68 ff ff ff       	call   801024ae <inb>
80102546:	0f b6 c0             	movzbl %al,%eax
80102549:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010254c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010254f:	25 c0 00 00 00       	and    $0xc0,%eax
80102554:	83 f8 40             	cmp    $0x40,%eax
80102557:	75 e1                	jne    8010253a <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102559:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010255d:	74 11                	je     80102570 <idewait+0x3d>
8010255f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102562:	83 e0 21             	and    $0x21,%eax
80102565:	85 c0                	test   %eax,%eax
80102567:	74 07                	je     80102570 <idewait+0x3d>
    return -1;
80102569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010256e:	eb 05                	jmp    80102575 <idewait+0x42>
  return 0;
80102570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102575:	c9                   	leave  
80102576:	c3                   	ret    

80102577 <ideinit>:

void
ideinit(void)
{
80102577:	55                   	push   %ebp
80102578:	89 e5                	mov    %esp,%ebp
8010257a:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  initlock(&idelock, "ide");
8010257d:	c7 44 24 04 2e 86 10 	movl   $0x8010862e,0x4(%esp)
80102584:	80 
80102585:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010258c:	e8 e1 28 00 00       	call   80104e72 <initlock>
  picenable(IRQ_IDE);
80102591:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102598:	e8 a3 18 00 00       	call   80103e40 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010259d:	a1 60 29 11 80       	mov    0x80112960,%eax
801025a2:	83 e8 01             	sub    $0x1,%eax
801025a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801025a9:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025b0:	e8 43 04 00 00       	call   801029f8 <ioapicenable>
  idewait(0);
801025b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025bc:	e8 72 ff ff ff       	call   80102533 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025c1:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025c8:	00 
801025c9:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025d0:	e8 1b ff ff ff       	call   801024f0 <outb>
  for(i=0; i<1000; i++){
801025d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025dc:	eb 20                	jmp    801025fe <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025de:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025e5:	e8 c4 fe ff ff       	call   801024ae <inb>
801025ea:	84 c0                	test   %al,%al
801025ec:	74 0c                	je     801025fa <ideinit+0x83>
      havedisk1 = 1;
801025ee:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025f5:	00 00 00 
      break;
801025f8:	eb 0d                	jmp    80102607 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025fe:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102605:	7e d7                	jle    801025de <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102607:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010260e:	00 
8010260f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102616:	e8 d5 fe ff ff       	call   801024f0 <outb>
}
8010261b:	c9                   	leave  
8010261c:	c3                   	ret    

8010261d <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010261d:	55                   	push   %ebp
8010261e:	89 e5                	mov    %esp,%ebp
80102620:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102623:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102627:	75 0c                	jne    80102635 <idestart+0x18>
    panic("idestart");
80102629:	c7 04 24 32 86 10 80 	movl   $0x80108632,(%esp)
80102630:	e8 05 df ff ff       	call   8010053a <panic>
  if(b->blockno >= FSSIZE)
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
80102638:	8b 40 08             	mov    0x8(%eax),%eax
8010263b:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102640:	76 0c                	jbe    8010264e <idestart+0x31>
    panic("incorrect blockno");
80102642:	c7 04 24 3b 86 10 80 	movl   $0x8010863b,(%esp)
80102649:	e8 ec de ff ff       	call   8010053a <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010264e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102655:	8b 45 08             	mov    0x8(%ebp),%eax
80102658:	8b 50 08             	mov    0x8(%eax),%edx
8010265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010265e:	0f af c2             	imul   %edx,%eax
80102661:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102664:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102668:	7e 0c                	jle    80102676 <idestart+0x59>
8010266a:	c7 04 24 32 86 10 80 	movl   $0x80108632,(%esp)
80102671:	e8 c4 de ff ff       	call   8010053a <panic>
  
  idewait(0);
80102676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010267d:	e8 b1 fe ff ff       	call   80102533 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102682:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102689:	00 
8010268a:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102691:	e8 5a fe ff ff       	call   801024f0 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102699:	0f b6 c0             	movzbl %al,%eax
8010269c:	89 44 24 04          	mov    %eax,0x4(%esp)
801026a0:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026a7:	e8 44 fe ff ff       	call   801024f0 <outb>
  outb(0x1f3, sector & 0xff);
801026ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026af:	0f b6 c0             	movzbl %al,%eax
801026b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801026b6:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026bd:	e8 2e fe ff ff       	call   801024f0 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801026c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026c5:	c1 f8 08             	sar    $0x8,%eax
801026c8:	0f b6 c0             	movzbl %al,%eax
801026cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cf:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026d6:	e8 15 fe ff ff       	call   801024f0 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026de:	c1 f8 10             	sar    $0x10,%eax
801026e1:	0f b6 c0             	movzbl %al,%eax
801026e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026e8:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026ef:	e8 fc fd ff ff       	call   801024f0 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026f4:	8b 45 08             	mov    0x8(%ebp),%eax
801026f7:	8b 40 04             	mov    0x4(%eax),%eax
801026fa:	83 e0 01             	and    $0x1,%eax
801026fd:	c1 e0 04             	shl    $0x4,%eax
80102700:	89 c2                	mov    %eax,%edx
80102702:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102705:	c1 f8 18             	sar    $0x18,%eax
80102708:	83 e0 0f             	and    $0xf,%eax
8010270b:	09 d0                	or     %edx,%eax
8010270d:	83 c8 e0             	or     $0xffffffe0,%eax
80102710:	0f b6 c0             	movzbl %al,%eax
80102713:	89 44 24 04          	mov    %eax,0x4(%esp)
80102717:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010271e:	e8 cd fd ff ff       	call   801024f0 <outb>
  if(b->flags & B_DIRTY){
80102723:	8b 45 08             	mov    0x8(%ebp),%eax
80102726:	8b 00                	mov    (%eax),%eax
80102728:	83 e0 04             	and    $0x4,%eax
8010272b:	85 c0                	test   %eax,%eax
8010272d:	74 34                	je     80102763 <idestart+0x146>
    outb(0x1f7, IDE_CMD_WRITE);
8010272f:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102736:	00 
80102737:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010273e:	e8 ad fd ff ff       	call   801024f0 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102743:	8b 45 08             	mov    0x8(%ebp),%eax
80102746:	83 c0 18             	add    $0x18,%eax
80102749:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102750:	00 
80102751:	89 44 24 04          	mov    %eax,0x4(%esp)
80102755:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010275c:	e8 ad fd ff ff       	call   8010250e <outsl>
80102761:	eb 14                	jmp    80102777 <idestart+0x15a>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102763:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010276a:	00 
8010276b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102772:	e8 79 fd ff ff       	call   801024f0 <outb>
  }
}
80102777:	c9                   	leave  
80102778:	c3                   	ret    

80102779 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102779:	55                   	push   %ebp
8010277a:	89 e5                	mov    %esp,%ebp
8010277c:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010277f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102786:	e8 08 27 00 00       	call   80104e93 <acquire>
  if((b = idequeue) == 0){
8010278b:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102790:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102797:	75 11                	jne    801027aa <ideintr+0x31>
    release(&idelock);
80102799:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027a0:	e8 50 27 00 00       	call   80104ef5 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801027a5:	e9 90 00 00 00       	jmp    8010283a <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ad:	8b 40 14             	mov    0x14(%eax),%eax
801027b0:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b8:	8b 00                	mov    (%eax),%eax
801027ba:	83 e0 04             	and    $0x4,%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 2e                	jne    801027ef <ideintr+0x76>
801027c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027c8:	e8 66 fd ff ff       	call   80102533 <idewait>
801027cd:	85 c0                	test   %eax,%eax
801027cf:	78 1e                	js     801027ef <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d4:	83 c0 18             	add    $0x18,%eax
801027d7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027de:	00 
801027df:	89 44 24 04          	mov    %eax,0x4(%esp)
801027e3:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027ea:	e8 dc fc ff ff       	call   801024cb <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f2:	8b 00                	mov    (%eax),%eax
801027f4:	83 c8 02             	or     $0x2,%eax
801027f7:	89 c2                	mov    %eax,%edx
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fc:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102801:	8b 00                	mov    (%eax),%eax
80102803:	83 e0 fb             	and    $0xfffffffb,%eax
80102806:	89 c2                	mov    %eax,%edx
80102808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102810:	89 04 24             	mov    %eax,(%esp)
80102813:	e8 80 24 00 00       	call   80104c98 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102818:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010281d:	85 c0                	test   %eax,%eax
8010281f:	74 0d                	je     8010282e <ideintr+0xb5>
    idestart(idequeue);
80102821:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102826:	89 04 24             	mov    %eax,(%esp)
80102829:	e8 ef fd ff ff       	call   8010261d <idestart>

  release(&idelock);
8010282e:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102835:	e8 bb 26 00 00       	call   80104ef5 <release>
}
8010283a:	c9                   	leave  
8010283b:	c3                   	ret    

8010283c <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010283c:	55                   	push   %ebp
8010283d:	89 e5                	mov    %esp,%ebp
8010283f:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102842:	8b 45 08             	mov    0x8(%ebp),%eax
80102845:	8b 00                	mov    (%eax),%eax
80102847:	83 e0 01             	and    $0x1,%eax
8010284a:	85 c0                	test   %eax,%eax
8010284c:	75 0c                	jne    8010285a <iderw+0x1e>
    panic("iderw: buf not busy");
8010284e:	c7 04 24 4d 86 10 80 	movl   $0x8010864d,(%esp)
80102855:	e8 e0 dc ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010285a:	8b 45 08             	mov    0x8(%ebp),%eax
8010285d:	8b 00                	mov    (%eax),%eax
8010285f:	83 e0 06             	and    $0x6,%eax
80102862:	83 f8 02             	cmp    $0x2,%eax
80102865:	75 0c                	jne    80102873 <iderw+0x37>
    panic("iderw: nothing to do");
80102867:	c7 04 24 61 86 10 80 	movl   $0x80108661,(%esp)
8010286e:	e8 c7 dc ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
80102873:	8b 45 08             	mov    0x8(%ebp),%eax
80102876:	8b 40 04             	mov    0x4(%eax),%eax
80102879:	85 c0                	test   %eax,%eax
8010287b:	74 15                	je     80102892 <iderw+0x56>
8010287d:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102882:	85 c0                	test   %eax,%eax
80102884:	75 0c                	jne    80102892 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102886:	c7 04 24 76 86 10 80 	movl   $0x80108676,(%esp)
8010288d:	e8 a8 dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102892:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102899:	e8 f5 25 00 00       	call   80104e93 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
8010289e:	8b 45 08             	mov    0x8(%ebp),%eax
801028a1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028a8:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801028af:	eb 0b                	jmp    801028bc <iderw+0x80>
801028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b4:	8b 00                	mov    (%eax),%eax
801028b6:	83 c0 14             	add    $0x14,%eax
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bf:	8b 00                	mov    (%eax),%eax
801028c1:	85 c0                	test   %eax,%eax
801028c3:	75 ec                	jne    801028b1 <iderw+0x75>
    ;
  *pp = b;
801028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c8:	8b 55 08             	mov    0x8(%ebp),%edx
801028cb:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028cd:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801028d5:	75 0d                	jne    801028e4 <iderw+0xa8>
    idestart(b);
801028d7:	8b 45 08             	mov    0x8(%ebp),%eax
801028da:	89 04 24             	mov    %eax,(%esp)
801028dd:	e8 3b fd ff ff       	call   8010261d <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028e2:	eb 15                	jmp    801028f9 <iderw+0xbd>
801028e4:	eb 13                	jmp    801028f9 <iderw+0xbd>
    sleep(b, &idelock);
801028e6:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
801028ed:	80 
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
801028f1:	89 04 24             	mov    %eax,(%esp)
801028f4:	e8 c6 22 00 00       	call   80104bbf <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028f9:	8b 45 08             	mov    0x8(%ebp),%eax
801028fc:	8b 00                	mov    (%eax),%eax
801028fe:	83 e0 06             	and    $0x6,%eax
80102901:	83 f8 02             	cmp    $0x2,%eax
80102904:	75 e0                	jne    801028e6 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102906:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010290d:	e8 e3 25 00 00       	call   80104ef5 <release>
}
80102912:	c9                   	leave  
80102913:	c3                   	ret    

80102914 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102914:	55                   	push   %ebp
80102915:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102917:	a1 34 22 11 80       	mov    0x80112234,%eax
8010291c:	8b 55 08             	mov    0x8(%ebp),%edx
8010291f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102921:	a1 34 22 11 80       	mov    0x80112234,%eax
80102926:	8b 40 10             	mov    0x10(%eax),%eax
}
80102929:	5d                   	pop    %ebp
8010292a:	c3                   	ret    

8010292b <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010292b:	55                   	push   %ebp
8010292c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010292e:	a1 34 22 11 80       	mov    0x80112234,%eax
80102933:	8b 55 08             	mov    0x8(%ebp),%edx
80102936:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102938:	a1 34 22 11 80       	mov    0x80112234,%eax
8010293d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102940:	89 50 10             	mov    %edx,0x10(%eax)
}
80102943:	5d                   	pop    %ebp
80102944:	c3                   	ret    

80102945 <ioapicinit>:

void
ioapicinit(void)
{
80102945:	55                   	push   %ebp
80102946:	89 e5                	mov    %esp,%ebp
80102948:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
8010294b:	a1 64 23 11 80       	mov    0x80112364,%eax
80102950:	85 c0                	test   %eax,%eax
80102952:	75 05                	jne    80102959 <ioapicinit+0x14>
    return;
80102954:	e9 9d 00 00 00       	jmp    801029f6 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102959:	c7 05 34 22 11 80 00 	movl   $0xfec00000,0x80112234
80102960:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102963:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010296a:	e8 a5 ff ff ff       	call   80102914 <ioapicread>
8010296f:	c1 e8 10             	shr    $0x10,%eax
80102972:	25 ff 00 00 00       	and    $0xff,%eax
80102977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
8010297a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102981:	e8 8e ff ff ff       	call   80102914 <ioapicread>
80102986:	c1 e8 18             	shr    $0x18,%eax
80102989:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
8010298c:	0f b6 05 60 23 11 80 	movzbl 0x80112360,%eax
80102993:	0f b6 c0             	movzbl %al,%eax
80102996:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102999:	74 0c                	je     801029a7 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010299b:	c7 04 24 94 86 10 80 	movl   $0x80108694,(%esp)
801029a2:	e8 f9 d9 ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029ae:	eb 3e                	jmp    801029ee <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b3:	83 c0 20             	add    $0x20,%eax
801029b6:	0d 00 00 01 00       	or     $0x10000,%eax
801029bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029be:	83 c2 08             	add    $0x8,%edx
801029c1:	01 d2                	add    %edx,%edx
801029c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c7:	89 14 24             	mov    %edx,(%esp)
801029ca:	e8 5c ff ff ff       	call   8010292b <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d2:	83 c0 08             	add    $0x8,%eax
801029d5:	01 c0                	add    %eax,%eax
801029d7:	83 c0 01             	add    $0x1,%eax
801029da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029e1:	00 
801029e2:	89 04 24             	mov    %eax,(%esp)
801029e5:	e8 41 ff ff ff       	call   8010292b <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029f4:	7e ba                	jle    801029b0 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029f6:	c9                   	leave  
801029f7:	c3                   	ret    

801029f8 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029f8:	55                   	push   %ebp
801029f9:	89 e5                	mov    %esp,%ebp
801029fb:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029fe:	a1 64 23 11 80       	mov    0x80112364,%eax
80102a03:	85 c0                	test   %eax,%eax
80102a05:	75 02                	jne    80102a09 <ioapicenable+0x11>
    return;
80102a07:	eb 37                	jmp    80102a40 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a09:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0c:	83 c0 20             	add    $0x20,%eax
80102a0f:	8b 55 08             	mov    0x8(%ebp),%edx
80102a12:	83 c2 08             	add    $0x8,%edx
80102a15:	01 d2                	add    %edx,%edx
80102a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a1b:	89 14 24             	mov    %edx,(%esp)
80102a1e:	e8 08 ff ff ff       	call   8010292b <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a23:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a26:	c1 e0 18             	shl    $0x18,%eax
80102a29:	8b 55 08             	mov    0x8(%ebp),%edx
80102a2c:	83 c2 08             	add    $0x8,%edx
80102a2f:	01 d2                	add    %edx,%edx
80102a31:	83 c2 01             	add    $0x1,%edx
80102a34:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a38:	89 14 24             	mov    %edx,(%esp)
80102a3b:	e8 eb fe ff ff       	call   8010292b <ioapicwrite>
}
80102a40:	c9                   	leave  
80102a41:	c3                   	ret    

80102a42 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a42:	55                   	push   %ebp
80102a43:	89 e5                	mov    %esp,%ebp
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	05 00 00 00 80       	add    $0x80000000,%eax
80102a4d:	5d                   	pop    %ebp
80102a4e:	c3                   	ret    

80102a4f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a4f:	55                   	push   %ebp
80102a50:	89 e5                	mov    %esp,%ebp
80102a52:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a55:	c7 44 24 04 c6 86 10 	movl   $0x801086c6,0x4(%esp)
80102a5c:	80 
80102a5d:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102a64:	e8 09 24 00 00       	call   80104e72 <initlock>
  kmem.use_lock = 0;
80102a69:	c7 05 74 22 11 80 00 	movl   $0x0,0x80112274
80102a70:	00 00 00 
  freerange(vstart, vend);
80102a73:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a76:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7d:	89 04 24             	mov    %eax,(%esp)
80102a80:	e8 26 00 00 00       	call   80102aab <freerange>
}
80102a85:	c9                   	leave  
80102a86:	c3                   	ret    

80102a87 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a87:	55                   	push   %ebp
80102a88:	89 e5                	mov    %esp,%ebp
80102a8a:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a90:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a94:	8b 45 08             	mov    0x8(%ebp),%eax
80102a97:	89 04 24             	mov    %eax,(%esp)
80102a9a:	e8 0c 00 00 00       	call   80102aab <freerange>
  kmem.use_lock = 1;
80102a9f:	c7 05 74 22 11 80 01 	movl   $0x1,0x80112274
80102aa6:	00 00 00 
}
80102aa9:	c9                   	leave  
80102aaa:	c3                   	ret    

80102aab <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aab:	55                   	push   %ebp
80102aac:	89 e5                	mov    %esp,%ebp
80102aae:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab4:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ab9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac1:	eb 12                	jmp    80102ad5 <freerange+0x2a>
    kfree(p);
80102ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac6:	89 04 24             	mov    %eax,(%esp)
80102ac9:	e8 16 00 00 00       	call   80102ae4 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ace:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	05 00 10 00 00       	add    $0x1000,%eax
80102add:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ae0:	76 e1                	jbe    80102ac3 <freerange+0x18>
    kfree(p);
}
80102ae2:	c9                   	leave  
80102ae3:	c3                   	ret    

80102ae4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ae4:	55                   	push   %ebp
80102ae5:	89 e5                	mov    %esp,%ebp
80102ae7:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aea:	8b 45 08             	mov    0x8(%ebp),%eax
80102aed:	25 ff 0f 00 00       	and    $0xfff,%eax
80102af2:	85 c0                	test   %eax,%eax
80102af4:	75 1b                	jne    80102b11 <kfree+0x2d>
80102af6:	81 7d 08 5c 51 11 80 	cmpl   $0x8011515c,0x8(%ebp)
80102afd:	72 12                	jb     80102b11 <kfree+0x2d>
80102aff:	8b 45 08             	mov    0x8(%ebp),%eax
80102b02:	89 04 24             	mov    %eax,(%esp)
80102b05:	e8 38 ff ff ff       	call   80102a42 <v2p>
80102b0a:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b0f:	76 0c                	jbe    80102b1d <kfree+0x39>
    panic("kfree");
80102b11:	c7 04 24 cb 86 10 80 	movl   $0x801086cb,(%esp)
80102b18:	e8 1d da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b1d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b24:	00 
80102b25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b2c:	00 
80102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b30:	89 04 24             	mov    %eax,(%esp)
80102b33:	e8 b9 25 00 00       	call   801050f1 <memset>

  if(kmem.use_lock)
80102b38:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b3d:	85 c0                	test   %eax,%eax
80102b3f:	74 0c                	je     80102b4d <kfree+0x69>
    acquire(&kmem.lock);
80102b41:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102b48:	e8 46 23 00 00       	call   80104e93 <acquire>
  r = (struct run*)v;
80102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b53:	8b 15 78 22 11 80    	mov    0x80112278,%edx
80102b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5c:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b61:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102b66:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	74 0c                	je     80102b7b <kfree+0x97>
    release(&kmem.lock);
80102b6f:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102b76:	e8 7a 23 00 00       	call   80104ef5 <release>
}
80102b7b:	c9                   	leave  
80102b7c:	c3                   	ret    

80102b7d <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b7d:	55                   	push   %ebp
80102b7e:	89 e5                	mov    %esp,%ebp
80102b80:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b83:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	74 0c                	je     80102b98 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b8c:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102b93:	e8 fb 22 00 00       	call   80104e93 <acquire>
  r = kmem.freelist;
80102b98:	a1 78 22 11 80       	mov    0x80112278,%eax
80102b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ba4:	74 0a                	je     80102bb0 <kalloc+0x33>
    kmem.freelist = r->next;
80102ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba9:	8b 00                	mov    (%eax),%eax
80102bab:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102bb0:	a1 74 22 11 80       	mov    0x80112274,%eax
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	74 0c                	je     80102bc5 <kalloc+0x48>
    release(&kmem.lock);
80102bb9:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102bc0:	e8 30 23 00 00       	call   80104ef5 <release>
  return (char*)r;
80102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bc8:	c9                   	leave  
80102bc9:	c3                   	ret    

80102bca <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bca:	55                   	push   %ebp
80102bcb:	89 e5                	mov    %esp,%ebp
80102bcd:	83 ec 14             	sub    $0x14,%esp
80102bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102bdb:	89 c2                	mov    %eax,%edx
80102bdd:	ec                   	in     (%dx),%al
80102bde:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102be1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102be5:	c9                   	leave  
80102be6:	c3                   	ret    

80102be7 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102be7:	55                   	push   %ebp
80102be8:	89 e5                	mov    %esp,%ebp
80102bea:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bed:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bf4:	e8 d1 ff ff ff       	call   80102bca <inb>
80102bf9:	0f b6 c0             	movzbl %al,%eax
80102bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c02:	83 e0 01             	and    $0x1,%eax
80102c05:	85 c0                	test   %eax,%eax
80102c07:	75 0a                	jne    80102c13 <kbdgetc+0x2c>
    return -1;
80102c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c0e:	e9 25 01 00 00       	jmp    80102d38 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c13:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c1a:	e8 ab ff ff ff       	call   80102bca <inb>
80102c1f:	0f b6 c0             	movzbl %al,%eax
80102c22:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c25:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c2c:	75 17                	jne    80102c45 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c2e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c33:	83 c8 40             	or     $0x40,%eax
80102c36:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c3b:	b8 00 00 00 00       	mov    $0x0,%eax
80102c40:	e9 f3 00 00 00       	jmp    80102d38 <kbdgetc+0x151>
  } else if(data & 0x80){
80102c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c48:	25 80 00 00 00       	and    $0x80,%eax
80102c4d:	85 c0                	test   %eax,%eax
80102c4f:	74 45                	je     80102c96 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c51:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c56:	83 e0 40             	and    $0x40,%eax
80102c59:	85 c0                	test   %eax,%eax
80102c5b:	75 08                	jne    80102c65 <kbdgetc+0x7e>
80102c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c60:	83 e0 7f             	and    $0x7f,%eax
80102c63:	eb 03                	jmp    80102c68 <kbdgetc+0x81>
80102c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6e:	05 20 90 10 80       	add    $0x80109020,%eax
80102c73:	0f b6 00             	movzbl (%eax),%eax
80102c76:	83 c8 40             	or     $0x40,%eax
80102c79:	0f b6 c0             	movzbl %al,%eax
80102c7c:	f7 d0                	not    %eax
80102c7e:	89 c2                	mov    %eax,%edx
80102c80:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c85:	21 d0                	and    %edx,%eax
80102c87:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c8c:	b8 00 00 00 00       	mov    $0x0,%eax
80102c91:	e9 a2 00 00 00       	jmp    80102d38 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c96:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c9b:	83 e0 40             	and    $0x40,%eax
80102c9e:	85 c0                	test   %eax,%eax
80102ca0:	74 14                	je     80102cb6 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ca2:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102ca9:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cae:	83 e0 bf             	and    $0xffffffbf,%eax
80102cb1:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cb9:	05 20 90 10 80       	add    $0x80109020,%eax
80102cbe:	0f b6 00             	movzbl (%eax),%eax
80102cc1:	0f b6 d0             	movzbl %al,%edx
80102cc4:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc9:	09 d0                	or     %edx,%eax
80102ccb:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd3:	05 20 91 10 80       	add    $0x80109120,%eax
80102cd8:	0f b6 00             	movzbl (%eax),%eax
80102cdb:	0f b6 d0             	movzbl %al,%edx
80102cde:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ce3:	31 d0                	xor    %edx,%eax
80102ce5:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cea:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cef:	83 e0 03             	and    $0x3,%eax
80102cf2:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfc:	01 d0                	add    %edx,%eax
80102cfe:	0f b6 00             	movzbl (%eax),%eax
80102d01:	0f b6 c0             	movzbl %al,%eax
80102d04:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d07:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d0c:	83 e0 08             	and    $0x8,%eax
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	74 22                	je     80102d35 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d13:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d17:	76 0c                	jbe    80102d25 <kbdgetc+0x13e>
80102d19:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d1d:	77 06                	ja     80102d25 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d1f:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d23:	eb 10                	jmp    80102d35 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d25:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d29:	76 0a                	jbe    80102d35 <kbdgetc+0x14e>
80102d2b:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d2f:	77 04                	ja     80102d35 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d31:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d35:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d38:	c9                   	leave  
80102d39:	c3                   	ret    

80102d3a <kbdintr>:

void
kbdintr(void)
{
80102d3a:	55                   	push   %ebp
80102d3b:	89 e5                	mov    %esp,%ebp
80102d3d:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d40:	c7 04 24 e7 2b 10 80 	movl   $0x80102be7,(%esp)
80102d47:	e8 61 da ff ff       	call   801007ad <consoleintr>
}
80102d4c:	c9                   	leave  
80102d4d:	c3                   	ret    

80102d4e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d4e:	55                   	push   %ebp
80102d4f:	89 e5                	mov    %esp,%ebp
80102d51:	83 ec 14             	sub    $0x14,%esp
80102d54:	8b 45 08             	mov    0x8(%ebp),%eax
80102d57:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d5f:	89 c2                	mov    %eax,%edx
80102d61:	ec                   	in     (%dx),%al
80102d62:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d65:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d69:	c9                   	leave  
80102d6a:	c3                   	ret    

80102d6b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d6b:	55                   	push   %ebp
80102d6c:	89 e5                	mov    %esp,%ebp
80102d6e:	83 ec 08             	sub    $0x8,%esp
80102d71:	8b 55 08             	mov    0x8(%ebp),%edx
80102d74:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d77:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d7b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d82:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d86:	ee                   	out    %al,(%dx)
}
80102d87:	c9                   	leave  
80102d88:	c3                   	ret    

80102d89 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d89:	55                   	push   %ebp
80102d8a:	89 e5                	mov    %esp,%ebp
80102d8c:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d8f:	9c                   	pushf  
80102d90:	58                   	pop    %eax
80102d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d97:	c9                   	leave  
80102d98:	c3                   	ret    

80102d99 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d99:	55                   	push   %ebp
80102d9a:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d9c:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102da1:	8b 55 08             	mov    0x8(%ebp),%edx
80102da4:	c1 e2 02             	shl    $0x2,%edx
80102da7:	01 c2                	add    %eax,%edx
80102da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dac:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dae:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102db3:	83 c0 20             	add    $0x20,%eax
80102db6:	8b 00                	mov    (%eax),%eax
}
80102db8:	5d                   	pop    %ebp
80102db9:	c3                   	ret    

80102dba <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102dba:	55                   	push   %ebp
80102dbb:	89 e5                	mov    %esp,%ebp
80102dbd:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102dc0:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102dc5:	85 c0                	test   %eax,%eax
80102dc7:	75 05                	jne    80102dce <lapicinit+0x14>
    return;
80102dc9:	e9 43 01 00 00       	jmp    80102f11 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dce:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dd5:	00 
80102dd6:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102ddd:	e8 b7 ff ff ff       	call   80102d99 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102de2:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102de9:	00 
80102dea:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102df1:	e8 a3 ff ff ff       	call   80102d99 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102df6:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102dfd:	00 
80102dfe:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e05:	e8 8f ff ff ff       	call   80102d99 <lapicw>
  lapicw(TICR, 10000000); 
80102e0a:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e11:	00 
80102e12:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e19:	e8 7b ff ff ff       	call   80102d99 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e1e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e25:	00 
80102e26:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e2d:	e8 67 ff ff ff       	call   80102d99 <lapicw>
  lapicw(LINT1, MASKED);
80102e32:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e39:	00 
80102e3a:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e41:	e8 53 ff ff ff       	call   80102d99 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e46:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102e4b:	83 c0 30             	add    $0x30,%eax
80102e4e:	8b 00                	mov    (%eax),%eax
80102e50:	c1 e8 10             	shr    $0x10,%eax
80102e53:	0f b6 c0             	movzbl %al,%eax
80102e56:	83 f8 03             	cmp    $0x3,%eax
80102e59:	76 14                	jbe    80102e6f <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e5b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e62:	00 
80102e63:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e6a:	e8 2a ff ff ff       	call   80102d99 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e6f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e76:	00 
80102e77:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e7e:	e8 16 ff ff ff       	call   80102d99 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e8a:	00 
80102e8b:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e92:	e8 02 ff ff ff       	call   80102d99 <lapicw>
  lapicw(ESR, 0);
80102e97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e9e:	00 
80102e9f:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ea6:	e8 ee fe ff ff       	call   80102d99 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102eab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb2:	00 
80102eb3:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102eba:	e8 da fe ff ff       	call   80102d99 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ebf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec6:	00 
80102ec7:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ece:	e8 c6 fe ff ff       	call   80102d99 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ed3:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102eda:	00 
80102edb:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ee2:	e8 b2 fe ff ff       	call   80102d99 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102ee7:	90                   	nop
80102ee8:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102eed:	05 00 03 00 00       	add    $0x300,%eax
80102ef2:	8b 00                	mov    (%eax),%eax
80102ef4:	25 00 10 00 00       	and    $0x1000,%eax
80102ef9:	85 c0                	test   %eax,%eax
80102efb:	75 eb                	jne    80102ee8 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102efd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f04:	00 
80102f05:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f0c:	e8 88 fe ff ff       	call   80102d99 <lapicw>
}
80102f11:	c9                   	leave  
80102f12:	c3                   	ret    

80102f13 <cpunum>:

int
cpunum(void)
{
80102f13:	55                   	push   %ebp
80102f14:	89 e5                	mov    %esp,%ebp
80102f16:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f19:	e8 6b fe ff ff       	call   80102d89 <readeflags>
80102f1e:	25 00 02 00 00       	and    $0x200,%eax
80102f23:	85 c0                	test   %eax,%eax
80102f25:	74 25                	je     80102f4c <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102f27:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f2c:	8d 50 01             	lea    0x1(%eax),%edx
80102f2f:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102f35:	85 c0                	test   %eax,%eax
80102f37:	75 13                	jne    80102f4c <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f39:	8b 45 04             	mov    0x4(%ebp),%eax
80102f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f40:	c7 04 24 d4 86 10 80 	movl   $0x801086d4,(%esp)
80102f47:	e8 54 d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f4c:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f51:	85 c0                	test   %eax,%eax
80102f53:	74 0f                	je     80102f64 <cpunum+0x51>
    return lapic[ID]>>24;
80102f55:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f5a:	83 c0 20             	add    $0x20,%eax
80102f5d:	8b 00                	mov    (%eax),%eax
80102f5f:	c1 e8 18             	shr    $0x18,%eax
80102f62:	eb 05                	jmp    80102f69 <cpunum+0x56>
  return 0;
80102f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f69:	c9                   	leave  
80102f6a:	c3                   	ret    

80102f6b <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f6b:	55                   	push   %ebp
80102f6c:	89 e5                	mov    %esp,%ebp
80102f6e:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f71:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102f76:	85 c0                	test   %eax,%eax
80102f78:	74 14                	je     80102f8e <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f81:	00 
80102f82:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f89:	e8 0b fe ff ff       	call   80102d99 <lapicw>
}
80102f8e:	c9                   	leave  
80102f8f:	c3                   	ret    

80102f90 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
}
80102f93:	5d                   	pop    %ebp
80102f94:	c3                   	ret    

80102f95 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f95:	55                   	push   %ebp
80102f96:	89 e5                	mov    %esp,%ebp
80102f98:	83 ec 1c             	sub    $0x1c,%esp
80102f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80102f9e:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fa1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102fa8:	00 
80102fa9:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fb0:	e8 b6 fd ff ff       	call   80102d6b <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fb5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fbc:	00 
80102fbd:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fc4:	e8 a2 fd ff ff       	call   80102d6b <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fc9:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fd3:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fdb:	8d 50 02             	lea    0x2(%eax),%edx
80102fde:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fe1:	c1 e8 04             	shr    $0x4,%eax
80102fe4:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fe7:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102feb:	c1 e0 18             	shl    $0x18,%eax
80102fee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff2:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ff9:	e8 9b fd ff ff       	call   80102d99 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ffe:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80103005:	00 
80103006:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010300d:	e8 87 fd ff ff       	call   80102d99 <lapicw>
  microdelay(200);
80103012:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103019:	e8 72 ff ff ff       	call   80102f90 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
8010301e:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103025:	00 
80103026:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010302d:	e8 67 fd ff ff       	call   80102d99 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103032:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80103039:	e8 52 ff ff ff       	call   80102f90 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010303e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103045:	eb 40                	jmp    80103087 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103047:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010304b:	c1 e0 18             	shl    $0x18,%eax
8010304e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103052:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103059:	e8 3b fd ff ff       	call   80102d99 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010305e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103061:	c1 e8 0c             	shr    $0xc,%eax
80103064:	80 cc 06             	or     $0x6,%ah
80103067:	89 44 24 04          	mov    %eax,0x4(%esp)
8010306b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103072:	e8 22 fd ff ff       	call   80102d99 <lapicw>
    microdelay(200);
80103077:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010307e:	e8 0d ff ff ff       	call   80102f90 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103083:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103087:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010308b:	7e ba                	jle    80103047 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010308d:	c9                   	leave  
8010308e:	c3                   	ret    

8010308f <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010308f:	55                   	push   %ebp
80103090:	89 e5                	mov    %esp,%ebp
80103092:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103095:	8b 45 08             	mov    0x8(%ebp),%eax
80103098:	0f b6 c0             	movzbl %al,%eax
8010309b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010309f:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030a6:	e8 c0 fc ff ff       	call   80102d6b <outb>
  microdelay(200);
801030ab:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030b2:	e8 d9 fe ff ff       	call   80102f90 <microdelay>

  return inb(CMOS_RETURN);
801030b7:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030be:	e8 8b fc ff ff       	call   80102d4e <inb>
801030c3:	0f b6 c0             	movzbl %al,%eax
}
801030c6:	c9                   	leave  
801030c7:	c3                   	ret    

801030c8 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030c8:	55                   	push   %ebp
801030c9:	89 e5                	mov    %esp,%ebp
801030cb:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030d5:	e8 b5 ff ff ff       	call   8010308f <cmos_read>
801030da:	8b 55 08             	mov    0x8(%ebp),%edx
801030dd:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030e6:	e8 a4 ff ff ff       	call   8010308f <cmos_read>
801030eb:	8b 55 08             	mov    0x8(%ebp),%edx
801030ee:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030f1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030f8:	e8 92 ff ff ff       	call   8010308f <cmos_read>
801030fd:	8b 55 08             	mov    0x8(%ebp),%edx
80103100:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103103:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
8010310a:	e8 80 ff ff ff       	call   8010308f <cmos_read>
8010310f:	8b 55 08             	mov    0x8(%ebp),%edx
80103112:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103115:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010311c:	e8 6e ff ff ff       	call   8010308f <cmos_read>
80103121:	8b 55 08             	mov    0x8(%ebp),%edx
80103124:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103127:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
8010312e:	e8 5c ff ff ff       	call   8010308f <cmos_read>
80103133:	8b 55 08             	mov    0x8(%ebp),%edx
80103136:	89 42 14             	mov    %eax,0x14(%edx)
}
80103139:	c9                   	leave  
8010313a:	c3                   	ret    

8010313b <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010313b:	55                   	push   %ebp
8010313c:	89 e5                	mov    %esp,%ebp
8010313e:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103141:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103148:	e8 42 ff ff ff       	call   8010308f <cmos_read>
8010314d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103153:	83 e0 04             	and    $0x4,%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	0f 94 c0             	sete   %al
8010315b:	0f b6 c0             	movzbl %al,%eax
8010315e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103161:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103164:	89 04 24             	mov    %eax,(%esp)
80103167:	e8 5c ff ff ff       	call   801030c8 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010316c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103173:	e8 17 ff ff ff       	call   8010308f <cmos_read>
80103178:	25 80 00 00 00       	and    $0x80,%eax
8010317d:	85 c0                	test   %eax,%eax
8010317f:	74 02                	je     80103183 <cmostime+0x48>
        continue;
80103181:	eb 36                	jmp    801031b9 <cmostime+0x7e>
    fill_rtcdate(&t2);
80103183:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103186:	89 04 24             	mov    %eax,(%esp)
80103189:	e8 3a ff ff ff       	call   801030c8 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010318e:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103195:	00 
80103196:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103199:	89 44 24 04          	mov    %eax,0x4(%esp)
8010319d:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031a0:	89 04 24             	mov    %eax,(%esp)
801031a3:	e8 c0 1f 00 00       	call   80105168 <memcmp>
801031a8:	85 c0                	test   %eax,%eax
801031aa:	75 0d                	jne    801031b9 <cmostime+0x7e>
      break;
801031ac:	90                   	nop
  }

  // convert
  if (bcd) {
801031ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031b1:	0f 84 ac 00 00 00    	je     80103263 <cmostime+0x128>
801031b7:	eb 02                	jmp    801031bb <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031b9:	eb a6                	jmp    80103161 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031be:	c1 e8 04             	shr    $0x4,%eax
801031c1:	89 c2                	mov    %eax,%edx
801031c3:	89 d0                	mov    %edx,%eax
801031c5:	c1 e0 02             	shl    $0x2,%eax
801031c8:	01 d0                	add    %edx,%eax
801031ca:	01 c0                	add    %eax,%eax
801031cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031cf:	83 e2 0f             	and    $0xf,%edx
801031d2:	01 d0                	add    %edx,%eax
801031d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031da:	c1 e8 04             	shr    $0x4,%eax
801031dd:	89 c2                	mov    %eax,%edx
801031df:	89 d0                	mov    %edx,%eax
801031e1:	c1 e0 02             	shl    $0x2,%eax
801031e4:	01 d0                	add    %edx,%eax
801031e6:	01 c0                	add    %eax,%eax
801031e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031eb:	83 e2 0f             	and    $0xf,%edx
801031ee:	01 d0                	add    %edx,%eax
801031f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031f6:	c1 e8 04             	shr    $0x4,%eax
801031f9:	89 c2                	mov    %eax,%edx
801031fb:	89 d0                	mov    %edx,%eax
801031fd:	c1 e0 02             	shl    $0x2,%eax
80103200:	01 d0                	add    %edx,%eax
80103202:	01 c0                	add    %eax,%eax
80103204:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103207:	83 e2 0f             	and    $0xf,%edx
8010320a:	01 d0                	add    %edx,%eax
8010320c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103212:	c1 e8 04             	shr    $0x4,%eax
80103215:	89 c2                	mov    %eax,%edx
80103217:	89 d0                	mov    %edx,%eax
80103219:	c1 e0 02             	shl    $0x2,%eax
8010321c:	01 d0                	add    %edx,%eax
8010321e:	01 c0                	add    %eax,%eax
80103220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103223:	83 e2 0f             	and    $0xf,%edx
80103226:	01 d0                	add    %edx,%eax
80103228:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010322e:	c1 e8 04             	shr    $0x4,%eax
80103231:	89 c2                	mov    %eax,%edx
80103233:	89 d0                	mov    %edx,%eax
80103235:	c1 e0 02             	shl    $0x2,%eax
80103238:	01 d0                	add    %edx,%eax
8010323a:	01 c0                	add    %eax,%eax
8010323c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010323f:	83 e2 0f             	and    $0xf,%edx
80103242:	01 d0                	add    %edx,%eax
80103244:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103247:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010324a:	c1 e8 04             	shr    $0x4,%eax
8010324d:	89 c2                	mov    %eax,%edx
8010324f:	89 d0                	mov    %edx,%eax
80103251:	c1 e0 02             	shl    $0x2,%eax
80103254:	01 d0                	add    %edx,%eax
80103256:	01 c0                	add    %eax,%eax
80103258:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010325b:	83 e2 0f             	and    $0xf,%edx
8010325e:	01 d0                	add    %edx,%eax
80103260:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103263:	8b 45 08             	mov    0x8(%ebp),%eax
80103266:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103269:	89 10                	mov    %edx,(%eax)
8010326b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010326e:	89 50 04             	mov    %edx,0x4(%eax)
80103271:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103274:	89 50 08             	mov    %edx,0x8(%eax)
80103277:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010327a:	89 50 0c             	mov    %edx,0xc(%eax)
8010327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103280:	89 50 10             	mov    %edx,0x10(%eax)
80103283:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103286:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103289:	8b 45 08             	mov    0x8(%ebp),%eax
8010328c:	8b 40 14             	mov    0x14(%eax),%eax
8010328f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103295:	8b 45 08             	mov    0x8(%ebp),%eax
80103298:	89 50 14             	mov    %edx,0x14(%eax)
}
8010329b:	c9                   	leave  
8010329c:	c3                   	ret    

8010329d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010329d:	55                   	push   %ebp
8010329e:	89 e5                	mov    %esp,%ebp
801032a0:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032a3:	c7 44 24 04 00 87 10 	movl   $0x80108700,0x4(%esp)
801032aa:	80 
801032ab:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801032b2:	e8 bb 1b 00 00       	call   80104e72 <initlock>
  readsb(dev, &sb);
801032b7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801032be:	8b 45 08             	mov    0x8(%ebp),%eax
801032c1:	89 04 24             	mov    %eax,(%esp)
801032c4:	e8 28 e0 ff ff       	call   801012f1 <readsb>
  log.start = sb.logstart;
801032c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032cc:	a3 b4 22 11 80       	mov    %eax,0x801122b4
  log.size = sb.nlog;
801032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032d4:	a3 b8 22 11 80       	mov    %eax,0x801122b8
  log.dev = dev;
801032d9:	8b 45 08             	mov    0x8(%ebp),%eax
801032dc:	a3 c4 22 11 80       	mov    %eax,0x801122c4
  recover_from_log();
801032e1:	e8 9a 01 00 00       	call   80103480 <recover_from_log>
}
801032e6:	c9                   	leave  
801032e7:	c3                   	ret    

801032e8 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032e8:	55                   	push   %ebp
801032e9:	89 e5                	mov    %esp,%ebp
801032eb:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032f5:	e9 8c 00 00 00       	jmp    80103386 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032fa:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
80103300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103303:	01 d0                	add    %edx,%eax
80103305:	83 c0 01             	add    $0x1,%eax
80103308:	89 c2                	mov    %eax,%edx
8010330a:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010330f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103313:	89 04 24             	mov    %eax,(%esp)
80103316:	e8 8b ce ff ff       	call   801001a6 <bread>
8010331b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103321:	83 c0 10             	add    $0x10,%eax
80103324:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
8010332b:	89 c2                	mov    %eax,%edx
8010332d:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103332:	89 54 24 04          	mov    %edx,0x4(%esp)
80103336:	89 04 24             	mov    %eax,(%esp)
80103339:	e8 68 ce ff ff       	call   801001a6 <bread>
8010333e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103341:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103344:	8d 50 18             	lea    0x18(%eax),%edx
80103347:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334a:	83 c0 18             	add    $0x18,%eax
8010334d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103354:	00 
80103355:	89 54 24 04          	mov    %edx,0x4(%esp)
80103359:	89 04 24             	mov    %eax,(%esp)
8010335c:	e8 5f 1e 00 00       	call   801051c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103361:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103364:	89 04 24             	mov    %eax,(%esp)
80103367:	e8 71 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010336c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010336f:	89 04 24             	mov    %eax,(%esp)
80103372:	e8 a0 ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103377:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337a:	89 04 24             	mov    %eax,(%esp)
8010337d:	e8 95 ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103382:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103386:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010338b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010338e:	0f 8f 66 ff ff ff    	jg     801032fa <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103394:	c9                   	leave  
80103395:	c3                   	ret    

80103396 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103396:	55                   	push   %ebp
80103397:	89 e5                	mov    %esp,%ebp
80103399:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010339c:	a1 b4 22 11 80       	mov    0x801122b4,%eax
801033a1:	89 c2                	mov    %eax,%edx
801033a3:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801033a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801033ac:	89 04 24             	mov    %eax,(%esp)
801033af:	e8 f2 cd ff ff       	call   801001a6 <bread>
801033b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ba:	83 c0 18             	add    $0x18,%eax
801033bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c3:	8b 00                	mov    (%eax),%eax
801033c5:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  for (i = 0; i < log.lh.n; i++) {
801033ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d1:	eb 1b                	jmp    801033ee <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801033d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033d9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e0:	83 c2 10             	add    $0x10,%edx
801033e3:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ee:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801033f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033f6:	7f db                	jg     801033d3 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801033f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033fb:	89 04 24             	mov    %eax,(%esp)
801033fe:	e8 14 ce ff ff       	call   80100217 <brelse>
}
80103403:	c9                   	leave  
80103404:	c3                   	ret    

80103405 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103405:	55                   	push   %ebp
80103406:	89 e5                	mov    %esp,%ebp
80103408:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010340b:	a1 b4 22 11 80       	mov    0x801122b4,%eax
80103410:	89 c2                	mov    %eax,%edx
80103412:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103417:	89 54 24 04          	mov    %edx,0x4(%esp)
8010341b:	89 04 24             	mov    %eax,(%esp)
8010341e:	e8 83 cd ff ff       	call   801001a6 <bread>
80103423:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103426:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103429:	83 c0 18             	add    $0x18,%eax
8010342c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010342f:	8b 15 c8 22 11 80    	mov    0x801122c8,%edx
80103435:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103438:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010343a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103441:	eb 1b                	jmp    8010345e <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103446:	83 c0 10             	add    $0x10,%eax
80103449:	8b 0c 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%ecx
80103450:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103453:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103456:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010345a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010345e:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103463:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103466:	7f db                	jg     80103443 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010346b:	89 04 24             	mov    %eax,(%esp)
8010346e:	e8 6a cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103476:	89 04 24             	mov    %eax,(%esp)
80103479:	e8 99 cd ff ff       	call   80100217 <brelse>
}
8010347e:	c9                   	leave  
8010347f:	c3                   	ret    

80103480 <recover_from_log>:

static void
recover_from_log(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103486:	e8 0b ff ff ff       	call   80103396 <read_head>
  install_trans(); // if committed, copy from log to disk
8010348b:	e8 58 fe ff ff       	call   801032e8 <install_trans>
  log.lh.n = 0;
80103490:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
80103497:	00 00 00 
  write_head(); // clear the log
8010349a:	e8 66 ff ff ff       	call   80103405 <write_head>
}
8010349f:	c9                   	leave  
801034a0:	c3                   	ret    

801034a1 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034a1:	55                   	push   %ebp
801034a2:	89 e5                	mov    %esp,%ebp
801034a4:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034a7:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801034ae:	e8 e0 19 00 00       	call   80104e93 <acquire>
  while(1){
    if(log.committing){
801034b3:	a1 c0 22 11 80       	mov    0x801122c0,%eax
801034b8:	85 c0                	test   %eax,%eax
801034ba:	74 16                	je     801034d2 <begin_op+0x31>
      sleep(&log, &log.lock);
801034bc:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
801034c3:	80 
801034c4:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801034cb:	e8 ef 16 00 00       	call   80104bbf <sleep>
801034d0:	eb 4f                	jmp    80103521 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034d2:	8b 0d c8 22 11 80    	mov    0x801122c8,%ecx
801034d8:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801034dd:	8d 50 01             	lea    0x1(%eax),%edx
801034e0:	89 d0                	mov    %edx,%eax
801034e2:	c1 e0 02             	shl    $0x2,%eax
801034e5:	01 d0                	add    %edx,%eax
801034e7:	01 c0                	add    %eax,%eax
801034e9:	01 c8                	add    %ecx,%eax
801034eb:	83 f8 1e             	cmp    $0x1e,%eax
801034ee:	7e 16                	jle    80103506 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034f0:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
801034f7:	80 
801034f8:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801034ff:	e8 bb 16 00 00       	call   80104bbf <sleep>
80103504:	eb 1b                	jmp    80103521 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103506:	a1 bc 22 11 80       	mov    0x801122bc,%eax
8010350b:	83 c0 01             	add    $0x1,%eax
8010350e:	a3 bc 22 11 80       	mov    %eax,0x801122bc
      release(&log.lock);
80103513:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010351a:	e8 d6 19 00 00       	call   80104ef5 <release>
      break;
8010351f:	eb 02                	jmp    80103523 <begin_op+0x82>
    }
  }
80103521:	eb 90                	jmp    801034b3 <begin_op+0x12>
}
80103523:	c9                   	leave  
80103524:	c3                   	ret    

80103525 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103525:	55                   	push   %ebp
80103526:	89 e5                	mov    %esp,%ebp
80103528:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010352b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103532:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103539:	e8 55 19 00 00       	call   80104e93 <acquire>
  log.outstanding -= 1;
8010353e:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103543:	83 e8 01             	sub    $0x1,%eax
80103546:	a3 bc 22 11 80       	mov    %eax,0x801122bc
  if(log.committing)
8010354b:	a1 c0 22 11 80       	mov    0x801122c0,%eax
80103550:	85 c0                	test   %eax,%eax
80103552:	74 0c                	je     80103560 <end_op+0x3b>
    panic("log.committing");
80103554:	c7 04 24 04 87 10 80 	movl   $0x80108704,(%esp)
8010355b:	e8 da cf ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
80103560:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103565:	85 c0                	test   %eax,%eax
80103567:	75 13                	jne    8010357c <end_op+0x57>
    do_commit = 1;
80103569:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103570:	c7 05 c0 22 11 80 01 	movl   $0x1,0x801122c0
80103577:	00 00 00 
8010357a:	eb 0c                	jmp    80103588 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010357c:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103583:	e8 10 17 00 00       	call   80104c98 <wakeup>
  }
  release(&log.lock);
80103588:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010358f:	e8 61 19 00 00       	call   80104ef5 <release>

  if(do_commit){
80103594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103598:	74 33                	je     801035cd <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010359a:	e8 de 00 00 00       	call   8010367d <commit>
    acquire(&log.lock);
8010359f:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801035a6:	e8 e8 18 00 00       	call   80104e93 <acquire>
    log.committing = 0;
801035ab:	c7 05 c0 22 11 80 00 	movl   $0x0,0x801122c0
801035b2:	00 00 00 
    wakeup(&log);
801035b5:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801035bc:	e8 d7 16 00 00       	call   80104c98 <wakeup>
    release(&log.lock);
801035c1:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801035c8:	e8 28 19 00 00       	call   80104ef5 <release>
  }
}
801035cd:	c9                   	leave  
801035ce:	c3                   	ret    

801035cf <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035cf:	55                   	push   %ebp
801035d0:	89 e5                	mov    %esp,%ebp
801035d2:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035dc:	e9 8c 00 00 00       	jmp    8010366d <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035e1:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
801035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ea:	01 d0                	add    %edx,%eax
801035ec:	83 c0 01             	add    $0x1,%eax
801035ef:	89 c2                	mov    %eax,%edx
801035f1:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801035f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801035fa:	89 04 24             	mov    %eax,(%esp)
801035fd:	e8 a4 cb ff ff       	call   801001a6 <bread>
80103602:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103608:	83 c0 10             	add    $0x10,%eax
8010360b:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103612:	89 c2                	mov    %eax,%edx
80103614:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103619:	89 54 24 04          	mov    %edx,0x4(%esp)
8010361d:	89 04 24             	mov    %eax,(%esp)
80103620:	e8 81 cb ff ff       	call   801001a6 <bread>
80103625:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103628:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010362b:	8d 50 18             	lea    0x18(%eax),%edx
8010362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103631:	83 c0 18             	add    $0x18,%eax
80103634:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010363b:	00 
8010363c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103640:	89 04 24             	mov    %eax,(%esp)
80103643:	e8 78 1b 00 00       	call   801051c0 <memmove>
    bwrite(to);  // write the log
80103648:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010364b:	89 04 24             	mov    %eax,(%esp)
8010364e:	e8 8a cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
80103653:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103656:	89 04 24             	mov    %eax,(%esp)
80103659:	e8 b9 cb ff ff       	call   80100217 <brelse>
    brelse(to);
8010365e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103661:	89 04 24             	mov    %eax,(%esp)
80103664:	e8 ae cb ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103669:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010366d:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103672:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103675:	0f 8f 66 ff ff ff    	jg     801035e1 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
8010367b:	c9                   	leave  
8010367c:	c3                   	ret    

8010367d <commit>:

static void
commit()
{
8010367d:	55                   	push   %ebp
8010367e:	89 e5                	mov    %esp,%ebp
80103680:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103683:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103688:	85 c0                	test   %eax,%eax
8010368a:	7e 1e                	jle    801036aa <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010368c:	e8 3e ff ff ff       	call   801035cf <write_log>
    write_head();    // Write header to disk -- the real commit
80103691:	e8 6f fd ff ff       	call   80103405 <write_head>
    install_trans(); // Now install writes to home locations
80103696:	e8 4d fc ff ff       	call   801032e8 <install_trans>
    log.lh.n = 0; 
8010369b:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
801036a2:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a5:	e8 5b fd ff ff       	call   80103405 <write_head>
  }
}
801036aa:	c9                   	leave  
801036ab:	c3                   	ret    

801036ac <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036ac:	55                   	push   %ebp
801036ad:	89 e5                	mov    %esp,%ebp
801036af:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036b2:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036b7:	83 f8 1d             	cmp    $0x1d,%eax
801036ba:	7f 12                	jg     801036ce <log_write+0x22>
801036bc:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036c1:	8b 15 b8 22 11 80    	mov    0x801122b8,%edx
801036c7:	83 ea 01             	sub    $0x1,%edx
801036ca:	39 d0                	cmp    %edx,%eax
801036cc:	7c 0c                	jl     801036da <log_write+0x2e>
    panic("too big a transaction");
801036ce:	c7 04 24 13 87 10 80 	movl   $0x80108713,(%esp)
801036d5:	e8 60 ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
801036da:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801036df:	85 c0                	test   %eax,%eax
801036e1:	7f 0c                	jg     801036ef <log_write+0x43>
    panic("log_write outside of trans");
801036e3:	c7 04 24 29 87 10 80 	movl   $0x80108729,(%esp)
801036ea:	e8 4b ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
801036ef:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801036f6:	e8 98 17 00 00       	call   80104e93 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103702:	eb 1f                	jmp    80103723 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103707:	83 c0 10             	add    $0x10,%eax
8010370a:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103711:	89 c2                	mov    %eax,%edx
80103713:	8b 45 08             	mov    0x8(%ebp),%eax
80103716:	8b 40 08             	mov    0x8(%eax),%eax
80103719:	39 c2                	cmp    %eax,%edx
8010371b:	75 02                	jne    8010371f <log_write+0x73>
      break;
8010371d:	eb 0e                	jmp    8010372d <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010371f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103723:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103728:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010372b:	7f d7                	jg     80103704 <log_write+0x58>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
8010372d:	8b 45 08             	mov    0x8(%ebp),%eax
80103730:	8b 40 08             	mov    0x8(%eax),%eax
80103733:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103736:	83 c2 10             	add    $0x10,%edx
80103739:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
  if (i == log.lh.n)
80103740:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103745:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103748:	75 0d                	jne    80103757 <log_write+0xab>
    log.lh.n++;
8010374a:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010374f:	83 c0 01             	add    $0x1,%eax
80103752:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  b->flags |= B_DIRTY; // prevent eviction
80103757:	8b 45 08             	mov    0x8(%ebp),%eax
8010375a:	8b 00                	mov    (%eax),%eax
8010375c:	83 c8 04             	or     $0x4,%eax
8010375f:	89 c2                	mov    %eax,%edx
80103761:	8b 45 08             	mov    0x8(%ebp),%eax
80103764:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103766:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010376d:	e8 83 17 00 00       	call   80104ef5 <release>
}
80103772:	c9                   	leave  
80103773:	c3                   	ret    

80103774 <v2p>:
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	8b 45 08             	mov    0x8(%ebp),%eax
8010377a:	05 00 00 00 80       	add    $0x80000000,%eax
8010377f:	5d                   	pop    %ebp
80103780:	c3                   	ret    

80103781 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103781:	55                   	push   %ebp
80103782:	89 e5                	mov    %esp,%ebp
80103784:	8b 45 08             	mov    0x8(%ebp),%eax
80103787:	05 00 00 00 80       	add    $0x80000000,%eax
8010378c:	5d                   	pop    %ebp
8010378d:	c3                   	ret    

8010378e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010378e:	55                   	push   %ebp
8010378f:	89 e5                	mov    %esp,%ebp
80103791:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103794:	8b 55 08             	mov    0x8(%ebp),%edx
80103797:	8b 45 0c             	mov    0xc(%ebp),%eax
8010379a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010379d:	f0 87 02             	lock xchg %eax,(%edx)
801037a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037a6:	c9                   	leave  
801037a7:	c3                   	ret    

801037a8 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037a8:	55                   	push   %ebp
801037a9:	89 e5                	mov    %esp,%ebp
801037ab:	83 e4 f0             	and    $0xfffffff0,%esp
801037ae:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037b1:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801037b8:	80 
801037b9:	c7 04 24 5c 51 11 80 	movl   $0x8011515c,(%esp)
801037c0:	e8 8a f2 ff ff       	call   80102a4f <kinit1>
  kvmalloc();      // kernel page table
801037c5:	e8 17 45 00 00       	call   80107ce1 <kvmalloc>
  mpinit();        // collect info about this machine
801037ca:	e8 41 04 00 00       	call   80103c10 <mpinit>
  lapicinit();
801037cf:	e8 e6 f5 ff ff       	call   80102dba <lapicinit>
  seginit();       // set up segments
801037d4:	e8 9b 3e 00 00       	call   80107674 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801037d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037df:	0f b6 00             	movzbl (%eax),%eax
801037e2:	0f b6 c0             	movzbl %al,%eax
801037e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801037e9:	c7 04 24 44 87 10 80 	movl   $0x80108744,(%esp)
801037f0:	e8 ab cb ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
801037f5:	e8 74 06 00 00       	call   80103e6e <picinit>
  ioapicinit();    // another interrupt controller
801037fa:	e8 46 f1 ff ff       	call   80102945 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801037ff:	e8 7d d2 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103804:	e8 ba 31 00 00       	call   801069c3 <uartinit>
  pinit();         // process table
80103809:	e8 6a 0b 00 00       	call   80104378 <pinit>
  tvinit();        // trap vectors
8010380e:	e8 62 2d 00 00       	call   80106575 <tvinit>
  binit();         // buffer cache
80103813:	e8 1c c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103818:	e8 ed d6 ff ff       	call   80100f0a <fileinit>
  ideinit();       // disk
8010381d:	e8 55 ed ff ff       	call   80102577 <ideinit>
  if(!ismp)
80103822:	a1 64 23 11 80       	mov    0x80112364,%eax
80103827:	85 c0                	test   %eax,%eax
80103829:	75 05                	jne    80103830 <main+0x88>
    timerinit();   // uniprocessor timer
8010382b:	e8 90 2c 00 00       	call   801064c0 <timerinit>
  startothers();   // start other processors
80103830:	e8 7f 00 00 00       	call   801038b4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103835:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010383c:	8e 
8010383d:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103844:	e8 3e f2 ff ff       	call   80102a87 <kinit2>
  userinit();      // first user process
80103849:	e8 45 0c 00 00       	call   80104493 <userinit>
  mpmain();
8010384e:	e8 1a 00 00 00       	call   8010386d <mpmain>

80103853 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103853:	55                   	push   %ebp
80103854:	89 e5                	mov    %esp,%ebp
80103856:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103859:	e8 9a 44 00 00       	call   80107cf8 <switchkvm>
  seginit();
8010385e:	e8 11 3e 00 00       	call   80107674 <seginit>
  lapicinit();
80103863:	e8 52 f5 ff ff       	call   80102dba <lapicinit>
  mpmain();
80103868:	e8 00 00 00 00       	call   8010386d <mpmain>

8010386d <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010386d:	55                   	push   %ebp
8010386e:	89 e5                	mov    %esp,%ebp
80103870:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103873:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103879:	0f b6 00             	movzbl (%eax),%eax
8010387c:	0f b6 c0             	movzbl %al,%eax
8010387f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103883:	c7 04 24 5b 87 10 80 	movl   $0x8010875b,(%esp)
8010388a:	e8 11 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
8010388f:	e8 55 2e 00 00       	call   801066e9 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103894:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010389a:	05 a8 00 00 00       	add    $0xa8,%eax
8010389f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038a6:	00 
801038a7:	89 04 24             	mov    %eax,(%esp)
801038aa:	e8 df fe ff ff       	call   8010378e <xchg>
  scheduler();     // start running processes
801038af:	e8 50 11 00 00       	call   80104a04 <scheduler>

801038b4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	53                   	push   %ebx
801038b8:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038bb:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801038c2:	e8 ba fe ff ff       	call   80103781 <p2v>
801038c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038ca:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038cf:	89 44 24 08          	mov    %eax,0x8(%esp)
801038d3:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
801038da:	80 
801038db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038de:	89 04 24             	mov    %eax,(%esp)
801038e1:	e8 da 18 00 00       	call   801051c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038e6:	c7 45 f4 80 23 11 80 	movl   $0x80112380,-0xc(%ebp)
801038ed:	e9 85 00 00 00       	jmp    80103977 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
801038f2:	e8 1c f6 ff ff       	call   80102f13 <cpunum>
801038f7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038fd:	05 80 23 11 80       	add    $0x80112380,%eax
80103902:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103905:	75 02                	jne    80103909 <startothers+0x55>
      continue;
80103907:	eb 67                	jmp    80103970 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103909:	e8 6f f2 ff ff       	call   80102b7d <kalloc>
8010390e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103911:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103914:	83 e8 04             	sub    $0x4,%eax
80103917:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010391a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103920:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103922:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103925:	83 e8 08             	sub    $0x8,%eax
80103928:	c7 00 53 38 10 80    	movl   $0x80103853,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103931:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103934:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
8010393b:	e8 34 fe ff ff       	call   80103774 <v2p>
80103940:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103942:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103945:	89 04 24             	mov    %eax,(%esp)
80103948:	e8 27 fe ff ff       	call   80103774 <v2p>
8010394d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103950:	0f b6 12             	movzbl (%edx),%edx
80103953:	0f b6 d2             	movzbl %dl,%edx
80103956:	89 44 24 04          	mov    %eax,0x4(%esp)
8010395a:	89 14 24             	mov    %edx,(%esp)
8010395d:	e8 33 f6 ff ff       	call   80102f95 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103962:	90                   	nop
80103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103966:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010396c:	85 c0                	test   %eax,%eax
8010396e:	74 f3                	je     80103963 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103970:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103977:	a1 60 29 11 80       	mov    0x80112960,%eax
8010397c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103982:	05 80 23 11 80       	add    $0x80112380,%eax
80103987:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010398a:	0f 87 62 ff ff ff    	ja     801038f2 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103990:	83 c4 24             	add    $0x24,%esp
80103993:	5b                   	pop    %ebx
80103994:	5d                   	pop    %ebp
80103995:	c3                   	ret    

80103996 <p2v>:
80103996:	55                   	push   %ebp
80103997:	89 e5                	mov    %esp,%ebp
80103999:	8b 45 08             	mov    0x8(%ebp),%eax
8010399c:	05 00 00 00 80       	add    $0x80000000,%eax
801039a1:	5d                   	pop    %ebp
801039a2:	c3                   	ret    

801039a3 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039a3:	55                   	push   %ebp
801039a4:	89 e5                	mov    %esp,%ebp
801039a6:	83 ec 14             	sub    $0x14,%esp
801039a9:	8b 45 08             	mov    0x8(%ebp),%eax
801039ac:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039b0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801039b4:	89 c2                	mov    %eax,%edx
801039b6:	ec                   	in     (%dx),%al
801039b7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801039ba:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801039be:	c9                   	leave  
801039bf:	c3                   	ret    

801039c0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
801039c6:	8b 55 08             	mov    0x8(%ebp),%edx
801039c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801039cc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039d0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039d3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039d7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801039db:	ee                   	out    %al,(%dx)
}
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    

801039de <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801039de:	55                   	push   %ebp
801039df:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801039e1:	a1 44 b6 10 80       	mov    0x8010b644,%eax
801039e6:	89 c2                	mov    %eax,%edx
801039e8:	b8 80 23 11 80       	mov    $0x80112380,%eax
801039ed:	29 c2                	sub    %eax,%edx
801039ef:	89 d0                	mov    %edx,%eax
801039f1:	c1 f8 02             	sar    $0x2,%eax
801039f4:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801039fa:	5d                   	pop    %ebp
801039fb:	c3                   	ret    

801039fc <sum>:

static uchar
sum(uchar *addr, int len)
{
801039fc:	55                   	push   %ebp
801039fd:	89 e5                	mov    %esp,%ebp
801039ff:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a10:	eb 15                	jmp    80103a27 <sum+0x2b>
    sum += addr[i];
80103a12:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a15:	8b 45 08             	mov    0x8(%ebp),%eax
80103a18:	01 d0                	add    %edx,%eax
80103a1a:	0f b6 00             	movzbl (%eax),%eax
80103a1d:	0f b6 c0             	movzbl %al,%eax
80103a20:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a23:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a2d:	7c e3                	jl     80103a12 <sum+0x16>
    sum += addr[i];
  return sum;
80103a2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a32:	c9                   	leave  
80103a33:	c3                   	ret    

80103a34 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3d:	89 04 24             	mov    %eax,(%esp)
80103a40:	e8 51 ff ff ff       	call   80103996 <p2v>
80103a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a4e:	01 d0                	add    %edx,%eax
80103a50:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a59:	eb 3f                	jmp    80103a9a <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a5b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a62:	00 
80103a63:	c7 44 24 04 6c 87 10 	movl   $0x8010876c,0x4(%esp)
80103a6a:	80 
80103a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6e:	89 04 24             	mov    %eax,(%esp)
80103a71:	e8 f2 16 00 00       	call   80105168 <memcmp>
80103a76:	85 c0                	test   %eax,%eax
80103a78:	75 1c                	jne    80103a96 <mpsearch1+0x62>
80103a7a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a81:	00 
80103a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a85:	89 04 24             	mov    %eax,(%esp)
80103a88:	e8 6f ff ff ff       	call   801039fc <sum>
80103a8d:	84 c0                	test   %al,%al
80103a8f:	75 05                	jne    80103a96 <mpsearch1+0x62>
      return (struct mp*)p;
80103a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a94:	eb 11                	jmp    80103aa7 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a96:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103aa0:	72 b9                	jb     80103a5b <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aa7:	c9                   	leave  
80103aa8:	c3                   	ret    

80103aa9 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103aa9:	55                   	push   %ebp
80103aaa:	89 e5                	mov    %esp,%ebp
80103aac:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103aaf:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab9:	83 c0 0f             	add    $0xf,%eax
80103abc:	0f b6 00             	movzbl (%eax),%eax
80103abf:	0f b6 c0             	movzbl %al,%eax
80103ac2:	c1 e0 08             	shl    $0x8,%eax
80103ac5:	89 c2                	mov    %eax,%edx
80103ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aca:	83 c0 0e             	add    $0xe,%eax
80103acd:	0f b6 00             	movzbl (%eax),%eax
80103ad0:	0f b6 c0             	movzbl %al,%eax
80103ad3:	09 d0                	or     %edx,%eax
80103ad5:	c1 e0 04             	shl    $0x4,%eax
80103ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103adf:	74 21                	je     80103b02 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103ae1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ae8:	00 
80103ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aec:	89 04 24             	mov    %eax,(%esp)
80103aef:	e8 40 ff ff ff       	call   80103a34 <mpsearch1>
80103af4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103af7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103afb:	74 50                	je     80103b4d <mpsearch+0xa4>
      return mp;
80103afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b00:	eb 5f                	jmp    80103b61 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b05:	83 c0 14             	add    $0x14,%eax
80103b08:	0f b6 00             	movzbl (%eax),%eax
80103b0b:	0f b6 c0             	movzbl %al,%eax
80103b0e:	c1 e0 08             	shl    $0x8,%eax
80103b11:	89 c2                	mov    %eax,%edx
80103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b16:	83 c0 13             	add    $0x13,%eax
80103b19:	0f b6 00             	movzbl (%eax),%eax
80103b1c:	0f b6 c0             	movzbl %al,%eax
80103b1f:	09 d0                	or     %edx,%eax
80103b21:	c1 e0 0a             	shl    $0xa,%eax
80103b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b2a:	2d 00 04 00 00       	sub    $0x400,%eax
80103b2f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b36:	00 
80103b37:	89 04 24             	mov    %eax,(%esp)
80103b3a:	e8 f5 fe ff ff       	call   80103a34 <mpsearch1>
80103b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b46:	74 05                	je     80103b4d <mpsearch+0xa4>
      return mp;
80103b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b4b:	eb 14                	jmp    80103b61 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b4d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b54:	00 
80103b55:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b5c:	e8 d3 fe ff ff       	call   80103a34 <mpsearch1>
}
80103b61:	c9                   	leave  
80103b62:	c3                   	ret    

80103b63 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b63:	55                   	push   %ebp
80103b64:	89 e5                	mov    %esp,%ebp
80103b66:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b69:	e8 3b ff ff ff       	call   80103aa9 <mpsearch>
80103b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b75:	74 0a                	je     80103b81 <mpconfig+0x1e>
80103b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b7a:	8b 40 04             	mov    0x4(%eax),%eax
80103b7d:	85 c0                	test   %eax,%eax
80103b7f:	75 0a                	jne    80103b8b <mpconfig+0x28>
    return 0;
80103b81:	b8 00 00 00 00       	mov    $0x0,%eax
80103b86:	e9 83 00 00 00       	jmp    80103c0e <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b8e:	8b 40 04             	mov    0x4(%eax),%eax
80103b91:	89 04 24             	mov    %eax,(%esp)
80103b94:	e8 fd fd ff ff       	call   80103996 <p2v>
80103b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b9c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103ba3:	00 
80103ba4:	c7 44 24 04 71 87 10 	movl   $0x80108771,0x4(%esp)
80103bab:	80 
80103bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103baf:	89 04 24             	mov    %eax,(%esp)
80103bb2:	e8 b1 15 00 00       	call   80105168 <memcmp>
80103bb7:	85 c0                	test   %eax,%eax
80103bb9:	74 07                	je     80103bc2 <mpconfig+0x5f>
    return 0;
80103bbb:	b8 00 00 00 00       	mov    $0x0,%eax
80103bc0:	eb 4c                	jmp    80103c0e <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc5:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bc9:	3c 01                	cmp    $0x1,%al
80103bcb:	74 12                	je     80103bdf <mpconfig+0x7c>
80103bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd0:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bd4:	3c 04                	cmp    $0x4,%al
80103bd6:	74 07                	je     80103bdf <mpconfig+0x7c>
    return 0;
80103bd8:	b8 00 00 00 00       	mov    $0x0,%eax
80103bdd:	eb 2f                	jmp    80103c0e <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103be6:	0f b7 c0             	movzwl %ax,%eax
80103be9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf0:	89 04 24             	mov    %eax,(%esp)
80103bf3:	e8 04 fe ff ff       	call   801039fc <sum>
80103bf8:	84 c0                	test   %al,%al
80103bfa:	74 07                	je     80103c03 <mpconfig+0xa0>
    return 0;
80103bfc:	b8 00 00 00 00       	mov    $0x0,%eax
80103c01:	eb 0b                	jmp    80103c0e <mpconfig+0xab>
  *pmp = mp;
80103c03:	8b 45 08             	mov    0x8(%ebp),%eax
80103c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c09:	89 10                	mov    %edx,(%eax)
  return conf;
80103c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c0e:	c9                   	leave  
80103c0f:	c3                   	ret    

80103c10 <mpinit>:

void
mpinit(void)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c16:	c7 05 44 b6 10 80 80 	movl   $0x80112380,0x8010b644
80103c1d:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c20:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c23:	89 04 24             	mov    %eax,(%esp)
80103c26:	e8 38 ff ff ff       	call   80103b63 <mpconfig>
80103c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c32:	75 05                	jne    80103c39 <mpinit+0x29>
    return;
80103c34:	e9 9c 01 00 00       	jmp    80103dd5 <mpinit+0x1c5>
  ismp = 1;
80103c39:	c7 05 64 23 11 80 01 	movl   $0x1,0x80112364
80103c40:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c46:	8b 40 24             	mov    0x24(%eax),%eax
80103c49:	a3 7c 22 11 80       	mov    %eax,0x8011227c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c51:	83 c0 2c             	add    $0x2c,%eax
80103c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c5a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c5e:	0f b7 d0             	movzwl %ax,%edx
80103c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c64:	01 d0                	add    %edx,%eax
80103c66:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c69:	e9 f4 00 00 00       	jmp    80103d62 <mpinit+0x152>
    switch(*p){
80103c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c71:	0f b6 00             	movzbl (%eax),%eax
80103c74:	0f b6 c0             	movzbl %al,%eax
80103c77:	83 f8 04             	cmp    $0x4,%eax
80103c7a:	0f 87 bf 00 00 00    	ja     80103d3f <mpinit+0x12f>
80103c80:	8b 04 85 b4 87 10 80 	mov    -0x7fef784c(,%eax,4),%eax
80103c87:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c92:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c96:	0f b6 d0             	movzbl %al,%edx
80103c99:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c9e:	39 c2                	cmp    %eax,%edx
80103ca0:	74 2d                	je     80103ccf <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103ca5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ca9:	0f b6 d0             	movzbl %al,%edx
80103cac:	a1 60 29 11 80       	mov    0x80112960,%eax
80103cb1:	89 54 24 08          	mov    %edx,0x8(%esp)
80103cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cb9:	c7 04 24 76 87 10 80 	movl   $0x80108776,(%esp)
80103cc0:	e8 db c6 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103cc5:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103ccc:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd2:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103cd6:	0f b6 c0             	movzbl %al,%eax
80103cd9:	83 e0 02             	and    $0x2,%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 15                	je     80103cf5 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103ce0:	a1 60 29 11 80       	mov    0x80112960,%eax
80103ce5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ceb:	05 80 23 11 80       	add    $0x80112380,%eax
80103cf0:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103cf5:	8b 15 60 29 11 80    	mov    0x80112960,%edx
80103cfb:	a1 60 29 11 80       	mov    0x80112960,%eax
80103d00:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103d06:	81 c2 80 23 11 80    	add    $0x80112380,%edx
80103d0c:	88 02                	mov    %al,(%edx)
      ncpu++;
80103d0e:	a1 60 29 11 80       	mov    0x80112960,%eax
80103d13:	83 c0 01             	add    $0x1,%eax
80103d16:	a3 60 29 11 80       	mov    %eax,0x80112960
      p += sizeof(struct mpproc);
80103d1b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d1f:	eb 41                	jmp    80103d62 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d2a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d2e:	a2 60 23 11 80       	mov    %al,0x80112360
      p += sizeof(struct mpioapic);
80103d33:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d37:	eb 29                	jmp    80103d62 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d39:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d3d:	eb 23                	jmp    80103d62 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d42:	0f b6 00             	movzbl (%eax),%eax
80103d45:	0f b6 c0             	movzbl %al,%eax
80103d48:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d4c:	c7 04 24 94 87 10 80 	movl   $0x80108794,(%esp)
80103d53:	e8 48 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103d58:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103d5f:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d68:	0f 82 00 ff ff ff    	jb     80103c6e <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d6e:	a1 64 23 11 80       	mov    0x80112364,%eax
80103d73:	85 c0                	test   %eax,%eax
80103d75:	75 1d                	jne    80103d94 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d77:	c7 05 60 29 11 80 01 	movl   $0x1,0x80112960
80103d7e:	00 00 00 
    lapic = 0;
80103d81:	c7 05 7c 22 11 80 00 	movl   $0x0,0x8011227c
80103d88:	00 00 00 
    ioapicid = 0;
80103d8b:	c6 05 60 23 11 80 00 	movb   $0x0,0x80112360
    return;
80103d92:	eb 41                	jmp    80103dd5 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d97:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d9b:	84 c0                	test   %al,%al
80103d9d:	74 36                	je     80103dd5 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d9f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103da6:	00 
80103da7:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103dae:	e8 0d fc ff ff       	call   801039c0 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103db3:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103dba:	e8 e4 fb ff ff       	call   801039a3 <inb>
80103dbf:	83 c8 01             	or     $0x1,%eax
80103dc2:	0f b6 c0             	movzbl %al,%eax
80103dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dc9:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103dd0:	e8 eb fb ff ff       	call   801039c0 <outb>
  }
}
80103dd5:	c9                   	leave  
80103dd6:	c3                   	ret    

80103dd7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dd7:	55                   	push   %ebp
80103dd8:	89 e5                	mov    %esp,%ebp
80103dda:	83 ec 08             	sub    $0x8,%esp
80103ddd:	8b 55 08             	mov    0x8(%ebp),%edx
80103de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103de7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dea:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103dee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103df2:	ee                   	out    %al,(%dx)
}
80103df3:	c9                   	leave  
80103df4:	c3                   	ret    

80103df5 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103df5:	55                   	push   %ebp
80103df6:	89 e5                	mov    %esp,%ebp
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e02:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e06:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e0c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e10:	0f b6 c0             	movzbl %al,%eax
80103e13:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e17:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e1e:	e8 b4 ff ff ff       	call   80103dd7 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e23:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e27:	66 c1 e8 08          	shr    $0x8,%ax
80103e2b:	0f b6 c0             	movzbl %al,%eax
80103e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e32:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e39:	e8 99 ff ff ff       	call   80103dd7 <outb>
}
80103e3e:	c9                   	leave  
80103e3f:	c3                   	ret    

80103e40 <picenable>:

void
picenable(int irq)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e46:	8b 45 08             	mov    0x8(%ebp),%eax
80103e49:	ba 01 00 00 00       	mov    $0x1,%edx
80103e4e:	89 c1                	mov    %eax,%ecx
80103e50:	d3 e2                	shl    %cl,%edx
80103e52:	89 d0                	mov    %edx,%eax
80103e54:	f7 d0                	not    %eax
80103e56:	89 c2                	mov    %eax,%edx
80103e58:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103e5f:	21 d0                	and    %edx,%eax
80103e61:	0f b7 c0             	movzwl %ax,%eax
80103e64:	89 04 24             	mov    %eax,(%esp)
80103e67:	e8 89 ff ff ff       	call   80103df5 <picsetmask>
}
80103e6c:	c9                   	leave  
80103e6d:	c3                   	ret    

80103e6e <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e6e:	55                   	push   %ebp
80103e6f:	89 e5                	mov    %esp,%ebp
80103e71:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e74:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e7b:	00 
80103e7c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e83:	e8 4f ff ff ff       	call   80103dd7 <outb>
  outb(IO_PIC2+1, 0xFF);
80103e88:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e8f:	00 
80103e90:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e97:	e8 3b ff ff ff       	call   80103dd7 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e9c:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ea3:	00 
80103ea4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103eab:	e8 27 ff ff ff       	call   80103dd7 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103eb0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103eb7:	00 
80103eb8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ebf:	e8 13 ff ff ff       	call   80103dd7 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ec4:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103ecb:	00 
80103ecc:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ed3:	e8 ff fe ff ff       	call   80103dd7 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ed8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103edf:	00 
80103ee0:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ee7:	e8 eb fe ff ff       	call   80103dd7 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103eec:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ef3:	00 
80103ef4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103efb:	e8 d7 fe ff ff       	call   80103dd7 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f00:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f07:	00 
80103f08:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f0f:	e8 c3 fe ff ff       	call   80103dd7 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f14:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f1b:	00 
80103f1c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f23:	e8 af fe ff ff       	call   80103dd7 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f28:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f2f:	00 
80103f30:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f37:	e8 9b fe ff ff       	call   80103dd7 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f3c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f43:	00 
80103f44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f4b:	e8 87 fe ff ff       	call   80103dd7 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f50:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f57:	00 
80103f58:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f5f:	e8 73 fe ff ff       	call   80103dd7 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f64:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f6b:	00 
80103f6c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f73:	e8 5f fe ff ff       	call   80103dd7 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f78:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f7f:	00 
80103f80:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f87:	e8 4b fe ff ff       	call   80103dd7 <outb>

  if(irqmask != 0xFFFF)
80103f8c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f93:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f97:	74 12                	je     80103fab <picinit+0x13d>
    picsetmask(irqmask);
80103f99:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fa0:	0f b7 c0             	movzwl %ax,%eax
80103fa3:	89 04 24             	mov    %eax,(%esp)
80103fa6:	e8 4a fe ff ff       	call   80103df5 <picsetmask>
}
80103fab:	c9                   	leave  
80103fac:	c3                   	ret    

80103fad <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fad:	55                   	push   %ebp
80103fae:	89 e5                	mov    %esp,%ebp
80103fb0:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fba:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fc6:	8b 10                	mov    (%eax),%edx
80103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcb:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fcd:	e8 54 cf ff ff       	call   80100f26 <filealloc>
80103fd2:	8b 55 08             	mov    0x8(%ebp),%edx
80103fd5:	89 02                	mov    %eax,(%edx)
80103fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fda:	8b 00                	mov    (%eax),%eax
80103fdc:	85 c0                	test   %eax,%eax
80103fde:	0f 84 c8 00 00 00    	je     801040ac <pipealloc+0xff>
80103fe4:	e8 3d cf ff ff       	call   80100f26 <filealloc>
80103fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fec:	89 02                	mov    %eax,(%edx)
80103fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff1:	8b 00                	mov    (%eax),%eax
80103ff3:	85 c0                	test   %eax,%eax
80103ff5:	0f 84 b1 00 00 00    	je     801040ac <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ffb:	e8 7d eb ff ff       	call   80102b7d <kalloc>
80104000:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104007:	75 05                	jne    8010400e <pipealloc+0x61>
    goto bad;
80104009:	e9 9e 00 00 00       	jmp    801040ac <pipealloc+0xff>
  p->readopen = 1;
8010400e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104011:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104018:	00 00 00 
  p->writeopen = 1;
8010401b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104025:	00 00 00 
  p->nwrite = 0;
80104028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104032:	00 00 00 
  p->nread = 0;
80104035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104038:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010403f:	00 00 00 
  initlock(&p->lock, "pipe");
80104042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104045:	c7 44 24 04 c8 87 10 	movl   $0x801087c8,0x4(%esp)
8010404c:	80 
8010404d:	89 04 24             	mov    %eax,(%esp)
80104050:	e8 1d 0e 00 00       	call   80104e72 <initlock>
  (*f0)->type = FD_PIPE;
80104055:	8b 45 08             	mov    0x8(%ebp),%eax
80104058:	8b 00                	mov    (%eax),%eax
8010405a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104060:	8b 45 08             	mov    0x8(%ebp),%eax
80104063:	8b 00                	mov    (%eax),%eax
80104065:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104069:	8b 45 08             	mov    0x8(%ebp),%eax
8010406c:	8b 00                	mov    (%eax),%eax
8010406e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104072:	8b 45 08             	mov    0x8(%ebp),%eax
80104075:	8b 00                	mov    (%eax),%eax
80104077:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010407a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010407d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104080:	8b 00                	mov    (%eax),%eax
80104082:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104088:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408b:	8b 00                	mov    (%eax),%eax
8010408d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104091:	8b 45 0c             	mov    0xc(%ebp),%eax
80104094:	8b 00                	mov    (%eax),%eax
80104096:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010409a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409d:	8b 00                	mov    (%eax),%eax
8010409f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a2:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040a5:	b8 00 00 00 00       	mov    $0x0,%eax
801040aa:	eb 42                	jmp    801040ee <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
801040ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040b0:	74 0b                	je     801040bd <pipealloc+0x110>
    kfree((char*)p);
801040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b5:	89 04 24             	mov    %eax,(%esp)
801040b8:	e8 27 ea ff ff       	call   80102ae4 <kfree>
  if(*f0)
801040bd:	8b 45 08             	mov    0x8(%ebp),%eax
801040c0:	8b 00                	mov    (%eax),%eax
801040c2:	85 c0                	test   %eax,%eax
801040c4:	74 0d                	je     801040d3 <pipealloc+0x126>
    fileclose(*f0);
801040c6:	8b 45 08             	mov    0x8(%ebp),%eax
801040c9:	8b 00                	mov    (%eax),%eax
801040cb:	89 04 24             	mov    %eax,(%esp)
801040ce:	e8 fb ce ff ff       	call   80100fce <fileclose>
  if(*f1)
801040d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040d6:	8b 00                	mov    (%eax),%eax
801040d8:	85 c0                	test   %eax,%eax
801040da:	74 0d                	je     801040e9 <pipealloc+0x13c>
    fileclose(*f1);
801040dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040df:	8b 00                	mov    (%eax),%eax
801040e1:	89 04 24             	mov    %eax,(%esp)
801040e4:	e8 e5 ce ff ff       	call   80100fce <fileclose>
  return -1;
801040e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040ee:	c9                   	leave  
801040ef:	c3                   	ret    

801040f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
801040f6:	8b 45 08             	mov    0x8(%ebp),%eax
801040f9:	89 04 24             	mov    %eax,(%esp)
801040fc:	e8 92 0d 00 00       	call   80104e93 <acquire>
  if(writable){
80104101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104105:	74 1f                	je     80104126 <pipeclose+0x36>
    p->writeopen = 0;
80104107:	8b 45 08             	mov    0x8(%ebp),%eax
8010410a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104111:	00 00 00 
    wakeup(&p->nread);
80104114:	8b 45 08             	mov    0x8(%ebp),%eax
80104117:	05 34 02 00 00       	add    $0x234,%eax
8010411c:	89 04 24             	mov    %eax,(%esp)
8010411f:	e8 74 0b 00 00       	call   80104c98 <wakeup>
80104124:	eb 1d                	jmp    80104143 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104126:	8b 45 08             	mov    0x8(%ebp),%eax
80104129:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104130:	00 00 00 
    wakeup(&p->nwrite);
80104133:	8b 45 08             	mov    0x8(%ebp),%eax
80104136:	05 38 02 00 00       	add    $0x238,%eax
8010413b:	89 04 24             	mov    %eax,(%esp)
8010413e:	e8 55 0b 00 00       	call   80104c98 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010414c:	85 c0                	test   %eax,%eax
8010414e:	75 25                	jne    80104175 <pipeclose+0x85>
80104150:	8b 45 08             	mov    0x8(%ebp),%eax
80104153:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	75 18                	jne    80104175 <pipeclose+0x85>
    release(&p->lock);
8010415d:	8b 45 08             	mov    0x8(%ebp),%eax
80104160:	89 04 24             	mov    %eax,(%esp)
80104163:	e8 8d 0d 00 00       	call   80104ef5 <release>
    kfree((char*)p);
80104168:	8b 45 08             	mov    0x8(%ebp),%eax
8010416b:	89 04 24             	mov    %eax,(%esp)
8010416e:	e8 71 e9 ff ff       	call   80102ae4 <kfree>
80104173:	eb 0b                	jmp    80104180 <pipeclose+0x90>
  } else
    release(&p->lock);
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	89 04 24             	mov    %eax,(%esp)
8010417b:	e8 75 0d 00 00       	call   80104ef5 <release>
}
80104180:	c9                   	leave  
80104181:	c3                   	ret    

80104182 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104182:	55                   	push   %ebp
80104183:	89 e5                	mov    %esp,%ebp
80104185:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104188:	8b 45 08             	mov    0x8(%ebp),%eax
8010418b:	89 04 24             	mov    %eax,(%esp)
8010418e:	e8 00 0d 00 00       	call   80104e93 <acquire>
  for(i = 0; i < n; i++){
80104193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010419a:	e9 a6 00 00 00       	jmp    80104245 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010419f:	eb 57                	jmp    801041f8 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
801041a1:	8b 45 08             	mov    0x8(%ebp),%eax
801041a4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041aa:	85 c0                	test   %eax,%eax
801041ac:	74 0d                	je     801041bb <pipewrite+0x39>
801041ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041b4:	8b 40 24             	mov    0x24(%eax),%eax
801041b7:	85 c0                	test   %eax,%eax
801041b9:	74 15                	je     801041d0 <pipewrite+0x4e>
        release(&p->lock);
801041bb:	8b 45 08             	mov    0x8(%ebp),%eax
801041be:	89 04 24             	mov    %eax,(%esp)
801041c1:	e8 2f 0d 00 00       	call   80104ef5 <release>
        return -1;
801041c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cb:	e9 9f 00 00 00       	jmp    8010426f <pipewrite+0xed>
      }
      wakeup(&p->nread);
801041d0:	8b 45 08             	mov    0x8(%ebp),%eax
801041d3:	05 34 02 00 00       	add    $0x234,%eax
801041d8:	89 04 24             	mov    %eax,(%esp)
801041db:	e8 b8 0a 00 00       	call   80104c98 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041e0:	8b 45 08             	mov    0x8(%ebp),%eax
801041e3:	8b 55 08             	mov    0x8(%ebp),%edx
801041e6:	81 c2 38 02 00 00    	add    $0x238,%edx
801041ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801041f0:	89 14 24             	mov    %edx,(%esp)
801041f3:	e8 c7 09 00 00       	call   80104bbf <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041f8:	8b 45 08             	mov    0x8(%ebp),%eax
801041fb:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010420a:	05 00 02 00 00       	add    $0x200,%eax
8010420f:	39 c2                	cmp    %eax,%edx
80104211:	74 8e                	je     801041a1 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104213:	8b 45 08             	mov    0x8(%ebp),%eax
80104216:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010421c:	8d 48 01             	lea    0x1(%eax),%ecx
8010421f:	8b 55 08             	mov    0x8(%ebp),%edx
80104222:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104228:	25 ff 01 00 00       	and    $0x1ff,%eax
8010422d:	89 c1                	mov    %eax,%ecx
8010422f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104232:	8b 45 0c             	mov    0xc(%ebp),%eax
80104235:	01 d0                	add    %edx,%eax
80104237:	0f b6 10             	movzbl (%eax),%edx
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104241:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104248:	3b 45 10             	cmp    0x10(%ebp),%eax
8010424b:	0f 8c 4e ff ff ff    	jl     8010419f <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104251:	8b 45 08             	mov    0x8(%ebp),%eax
80104254:	05 34 02 00 00       	add    $0x234,%eax
80104259:	89 04 24             	mov    %eax,(%esp)
8010425c:	e8 37 0a 00 00       	call   80104c98 <wakeup>
  release(&p->lock);
80104261:	8b 45 08             	mov    0x8(%ebp),%eax
80104264:	89 04 24             	mov    %eax,(%esp)
80104267:	e8 89 0c 00 00       	call   80104ef5 <release>
  return n;
8010426c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010426f:	c9                   	leave  
80104270:	c3                   	ret    

80104271 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104271:	55                   	push   %ebp
80104272:	89 e5                	mov    %esp,%ebp
80104274:	53                   	push   %ebx
80104275:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104278:	8b 45 08             	mov    0x8(%ebp),%eax
8010427b:	89 04 24             	mov    %eax,(%esp)
8010427e:	e8 10 0c 00 00       	call   80104e93 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104283:	eb 3a                	jmp    801042bf <piperead+0x4e>
    if(proc->killed){
80104285:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010428b:	8b 40 24             	mov    0x24(%eax),%eax
8010428e:	85 c0                	test   %eax,%eax
80104290:	74 15                	je     801042a7 <piperead+0x36>
      release(&p->lock);
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	89 04 24             	mov    %eax,(%esp)
80104298:	e8 58 0c 00 00       	call   80104ef5 <release>
      return -1;
8010429d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042a2:	e9 b5 00 00 00       	jmp    8010435c <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042a7:	8b 45 08             	mov    0x8(%ebp),%eax
801042aa:	8b 55 08             	mov    0x8(%ebp),%edx
801042ad:	81 c2 34 02 00 00    	add    $0x234,%edx
801042b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801042b7:	89 14 24             	mov    %edx,(%esp)
801042ba:	e8 00 09 00 00       	call   80104bbf <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042bf:	8b 45 08             	mov    0x8(%ebp),%eax
801042c2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042c8:	8b 45 08             	mov    0x8(%ebp),%eax
801042cb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042d1:	39 c2                	cmp    %eax,%edx
801042d3:	75 0d                	jne    801042e2 <piperead+0x71>
801042d5:	8b 45 08             	mov    0x8(%ebp),%eax
801042d8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042de:	85 c0                	test   %eax,%eax
801042e0:	75 a3                	jne    80104285 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042e9:	eb 4b                	jmp    80104336 <piperead+0xc5>
    if(p->nread == p->nwrite)
801042eb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ee:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042f4:	8b 45 08             	mov    0x8(%ebp),%eax
801042f7:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042fd:	39 c2                	cmp    %eax,%edx
801042ff:	75 02                	jne    80104303 <piperead+0x92>
      break;
80104301:	eb 3b                	jmp    8010433e <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104303:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104306:	8b 45 0c             	mov    0xc(%ebp),%eax
80104309:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010430c:	8b 45 08             	mov    0x8(%ebp),%eax
8010430f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104315:	8d 48 01             	lea    0x1(%eax),%ecx
80104318:	8b 55 08             	mov    0x8(%ebp),%edx
8010431b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104321:	25 ff 01 00 00       	and    $0x1ff,%eax
80104326:	89 c2                	mov    %eax,%edx
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104330:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104332:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104339:	3b 45 10             	cmp    0x10(%ebp),%eax
8010433c:	7c ad                	jl     801042eb <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010433e:	8b 45 08             	mov    0x8(%ebp),%eax
80104341:	05 38 02 00 00       	add    $0x238,%eax
80104346:	89 04 24             	mov    %eax,(%esp)
80104349:	e8 4a 09 00 00       	call   80104c98 <wakeup>
  release(&p->lock);
8010434e:	8b 45 08             	mov    0x8(%ebp),%eax
80104351:	89 04 24             	mov    %eax,(%esp)
80104354:	e8 9c 0b 00 00       	call   80104ef5 <release>
  return i;
80104359:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010435c:	83 c4 24             	add    $0x24,%esp
8010435f:	5b                   	pop    %ebx
80104360:	5d                   	pop    %ebp
80104361:	c3                   	ret    

80104362 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104362:	55                   	push   %ebp
80104363:	89 e5                	mov    %esp,%ebp
80104365:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104368:	9c                   	pushf  
80104369:	58                   	pop    %eax
8010436a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010436d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104370:	c9                   	leave  
80104371:	c3                   	ret    

80104372 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104372:	55                   	push   %ebp
80104373:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104375:	fb                   	sti    
}
80104376:	5d                   	pop    %ebp
80104377:	c3                   	ret    

80104378 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104378:	55                   	push   %ebp
80104379:	89 e5                	mov    %esp,%ebp
8010437b:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010437e:	c7 44 24 04 cd 87 10 	movl   $0x801087cd,0x4(%esp)
80104385:	80 
80104386:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010438d:	e8 e0 0a 00 00       	call   80104e72 <initlock>
}
80104392:	c9                   	leave  
80104393:	c3                   	ret    

80104394 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010439a:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801043a1:	e8 ed 0a 00 00       	call   80104e93 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a6:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
801043ad:	eb 50                	jmp    801043ff <allocproc+0x6b>
    if(p->state == UNUSED)
801043af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b2:	8b 40 0c             	mov    0xc(%eax),%eax
801043b5:	85 c0                	test   %eax,%eax
801043b7:	75 42                	jne    801043fb <allocproc+0x67>
      goto found;
801043b9:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bd:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801043c4:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801043c9:	8d 50 01             	lea    0x1(%eax),%edx
801043cc:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
801043d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d5:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801043d8:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801043df:	e8 11 0b 00 00       	call   80104ef5 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801043e4:	e8 94 e7 ff ff       	call   80102b7d <kalloc>
801043e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ec:	89 42 08             	mov    %eax,0x8(%edx)
801043ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f2:	8b 40 08             	mov    0x8(%eax),%eax
801043f5:	85 c0                	test   %eax,%eax
801043f7:	75 33                	jne    8010442c <allocproc+0x98>
801043f9:	eb 20                	jmp    8010441b <allocproc+0x87>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fb:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801043ff:	81 7d f4 b4 48 11 80 	cmpl   $0x801148b4,-0xc(%ebp)
80104406:	72 a7                	jb     801043af <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104408:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010440f:	e8 e1 0a 00 00       	call   80104ef5 <release>
  return 0;
80104414:	b8 00 00 00 00       	mov    $0x0,%eax
80104419:	eb 76                	jmp    80104491 <allocproc+0xfd>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010441b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104425:	b8 00 00 00 00       	mov    $0x0,%eax
8010442a:	eb 65                	jmp    80104491 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
8010442c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442f:	8b 40 08             	mov    0x8(%eax),%eax
80104432:	05 00 10 00 00       	add    $0x1000,%eax
80104437:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010443a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010443e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104441:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104444:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104447:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010444b:	ba 30 65 10 80       	mov    $0x80106530,%edx
80104450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104453:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104455:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010445f:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104465:	8b 40 1c             	mov    0x1c(%eax),%eax
80104468:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010446f:	00 
80104470:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104477:	00 
80104478:	89 04 24             	mov    %eax,(%esp)
8010447b:	e8 71 0c 00 00       	call   801050f1 <memset>
  p->context->eip = (uint)forkret;
80104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104483:	8b 40 1c             	mov    0x1c(%eax),%eax
80104486:	ba 80 4b 10 80       	mov    $0x80104b80,%edx
8010448b:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010448e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104491:	c9                   	leave  
80104492:	c3                   	ret    

80104493 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104493:	55                   	push   %ebp
80104494:	89 e5                	mov    %esp,%ebp
80104496:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104499:	e8 f6 fe ff ff       	call   80104394 <allocproc>
8010449e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801044a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a4:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
801044a9:	e8 76 37 00 00       	call   80107c24 <setupkvm>
801044ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044b1:	89 42 04             	mov    %eax,0x4(%edx)
801044b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b7:	8b 40 04             	mov    0x4(%eax),%eax
801044ba:	85 c0                	test   %eax,%eax
801044bc:	75 0c                	jne    801044ca <userinit+0x37>
    panic("userinit: out of memory?");
801044be:	c7 04 24 d4 87 10 80 	movl   $0x801087d4,(%esp)
801044c5:	e8 70 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044ca:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d2:	8b 40 04             	mov    0x4(%eax),%eax
801044d5:	89 54 24 08          	mov    %edx,0x8(%esp)
801044d9:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801044e0:	80 
801044e1:	89 04 24             	mov    %eax,(%esp)
801044e4:	e8 93 39 00 00       	call   80107e7c <inituvm>
  p->sz = PGSIZE;
801044e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ec:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801044f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f5:	8b 40 18             	mov    0x18(%eax),%eax
801044f8:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801044ff:	00 
80104500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104507:	00 
80104508:	89 04 24             	mov    %eax,(%esp)
8010450b:	e8 e1 0b 00 00       	call   801050f1 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104513:	8b 40 18             	mov    0x18(%eax),%eax
80104516:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010451c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451f:	8b 40 18             	mov    0x18(%eax),%eax
80104522:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452b:	8b 40 18             	mov    0x18(%eax),%eax
8010452e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104531:	8b 52 18             	mov    0x18(%edx),%edx
80104534:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104538:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010453c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453f:	8b 40 18             	mov    0x18(%eax),%eax
80104542:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104545:	8b 52 18             	mov    0x18(%edx),%edx
80104548:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010454c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104553:	8b 40 18             	mov    0x18(%eax),%eax
80104556:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010455d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104560:	8b 40 18             	mov    0x18(%eax),%eax
80104563:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010456a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456d:	8b 40 18             	mov    0x18(%eax),%eax
80104570:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457a:	83 c0 6c             	add    $0x6c,%eax
8010457d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104584:	00 
80104585:	c7 44 24 04 ed 87 10 	movl   $0x801087ed,0x4(%esp)
8010458c:	80 
8010458d:	89 04 24             	mov    %eax,(%esp)
80104590:	e8 7c 0d 00 00       	call   80105311 <safestrcpy>
  p->cwd = namei("/");
80104595:	c7 04 24 f6 87 10 80 	movl   $0x801087f6,(%esp)
8010459c:	e8 c9 de ff ff       	call   8010246a <namei>
801045a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a4:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801045a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045aa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801045b1:	c9                   	leave  
801045b2:	c3                   	ret    

801045b3 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045b3:	55                   	push   %ebp
801045b4:	89 e5                	mov    %esp,%ebp
801045b6:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801045b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045bf:	8b 00                	mov    (%eax),%eax
801045c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045c8:	7e 34                	jle    801045fe <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801045ca:	8b 55 08             	mov    0x8(%ebp),%edx
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	01 c2                	add    %eax,%edx
801045d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045d8:	8b 40 04             	mov    0x4(%eax),%eax
801045db:	89 54 24 08          	mov    %edx,0x8(%esp)
801045df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801045e6:	89 04 24             	mov    %eax,(%esp)
801045e9:	e8 04 3a 00 00       	call   80107ff2 <allocuvm>
801045ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045f5:	75 41                	jne    80104638 <growproc+0x85>
      return -1;
801045f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fc:	eb 58                	jmp    80104656 <growproc+0xa3>
  } else if(n < 0){
801045fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104602:	79 34                	jns    80104638 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104604:	8b 55 08             	mov    0x8(%ebp),%edx
80104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460a:	01 c2                	add    %eax,%edx
8010460c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104612:	8b 40 04             	mov    0x4(%eax),%eax
80104615:	89 54 24 08          	mov    %edx,0x8(%esp)
80104619:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010461c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104620:	89 04 24             	mov    %eax,(%esp)
80104623:	e8 a4 3a 00 00       	call   801080cc <deallocuvm>
80104628:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010462b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010462f:	75 07                	jne    80104638 <growproc+0x85>
      return -1;
80104631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104636:	eb 1e                	jmp    80104656 <growproc+0xa3>
  }
  proc->sz = sz;
80104638:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104641:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104643:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104649:	89 04 24             	mov    %eax,(%esp)
8010464c:	e8 c4 36 00 00       	call   80107d15 <switchuvm>
  return 0;
80104651:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104656:	c9                   	leave  
80104657:	c3                   	ret    

80104658 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104658:	55                   	push   %ebp
80104659:	89 e5                	mov    %esp,%ebp
8010465b:	57                   	push   %edi
8010465c:	56                   	push   %esi
8010465d:	53                   	push   %ebx
8010465e:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104661:	e8 2e fd ff ff       	call   80104394 <allocproc>
80104666:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104669:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010466d:	75 0a                	jne    80104679 <fork+0x21>
    return -1;
8010466f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104674:	e9 52 01 00 00       	jmp    801047cb <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104679:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467f:	8b 10                	mov    (%eax),%edx
80104681:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104687:	8b 40 04             	mov    0x4(%eax),%eax
8010468a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010468e:	89 04 24             	mov    %eax,(%esp)
80104691:	e8 d2 3b 00 00       	call   80108268 <copyuvm>
80104696:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104699:	89 42 04             	mov    %eax,0x4(%edx)
8010469c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010469f:	8b 40 04             	mov    0x4(%eax),%eax
801046a2:	85 c0                	test   %eax,%eax
801046a4:	75 2c                	jne    801046d2 <fork+0x7a>
    kfree(np->kstack);
801046a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a9:	8b 40 08             	mov    0x8(%eax),%eax
801046ac:	89 04 24             	mov    %eax,(%esp)
801046af:	e8 30 e4 ff ff       	call   80102ae4 <kfree>
    np->kstack = 0;
801046b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801046be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801046c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046cd:	e9 f9 00 00 00       	jmp    801047cb <fork+0x173>
  }
  np->sz = proc->sz;
801046d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d8:	8b 10                	mov    (%eax),%edx
801046da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046dd:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801046df:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e9:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801046ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ef:	8b 50 18             	mov    0x18(%eax),%edx
801046f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f8:	8b 40 18             	mov    0x18(%eax),%eax
801046fb:	89 c3                	mov    %eax,%ebx
801046fd:	b8 13 00 00 00       	mov    $0x13,%eax
80104702:	89 d7                	mov    %edx,%edi
80104704:	89 de                	mov    %ebx,%esi
80104706:	89 c1                	mov    %eax,%ecx
80104708:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010470a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010470d:	8b 40 18             	mov    0x18(%eax),%eax
80104710:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104717:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010471e:	eb 3d                	jmp    8010475d <fork+0x105>
    if(proc->ofile[i])
80104720:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104726:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104729:	83 c2 08             	add    $0x8,%edx
8010472c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104730:	85 c0                	test   %eax,%eax
80104732:	74 25                	je     80104759 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104734:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010473d:	83 c2 08             	add    $0x8,%edx
80104740:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104744:	89 04 24             	mov    %eax,(%esp)
80104747:	e8 3a c8 ff ff       	call   80100f86 <filedup>
8010474c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010474f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104752:	83 c1 08             	add    $0x8,%ecx
80104755:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104759:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010475d:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104761:	7e bd                	jle    80104720 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104763:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104769:	8b 40 68             	mov    0x68(%eax),%eax
8010476c:	89 04 24             	mov    %eax,(%esp)
8010476f:	e8 13 d1 ff ff       	call   80101887 <idup>
80104774:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104777:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010477a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104780:	8d 50 6c             	lea    0x6c(%eax),%edx
80104783:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104786:	83 c0 6c             	add    $0x6c,%eax
80104789:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104790:	00 
80104791:	89 54 24 04          	mov    %edx,0x4(%esp)
80104795:	89 04 24             	mov    %eax,(%esp)
80104798:	e8 74 0b 00 00       	call   80105311 <safestrcpy>
 
  pid = np->pid;
8010479d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047a0:	8b 40 10             	mov    0x10(%eax),%eax
801047a3:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801047a6:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801047ad:	e8 e1 06 00 00       	call   80104e93 <acquire>
  np->state = RUNNABLE;
801047b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801047bc:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801047c3:	e8 2d 07 00 00       	call   80104ef5 <release>
  
  return pid;
801047c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801047cb:	83 c4 2c             	add    $0x2c,%esp
801047ce:	5b                   	pop    %ebx
801047cf:	5e                   	pop    %esi
801047d0:	5f                   	pop    %edi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    

801047d3 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801047d3:	55                   	push   %ebp
801047d4:	89 e5                	mov    %esp,%ebp
801047d6:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801047d9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047e0:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801047e5:	39 c2                	cmp    %eax,%edx
801047e7:	75 0c                	jne    801047f5 <exit+0x22>
    panic("init exiting");
801047e9:	c7 04 24 f8 87 10 80 	movl   $0x801087f8,(%esp)
801047f0:	e8 45 bd ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801047fc:	eb 44                	jmp    80104842 <exit+0x6f>
    if(proc->ofile[fd]){
801047fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104804:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104807:	83 c2 08             	add    $0x8,%edx
8010480a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010480e:	85 c0                	test   %eax,%eax
80104810:	74 2c                	je     8010483e <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104818:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010481b:	83 c2 08             	add    $0x8,%edx
8010481e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104822:	89 04 24             	mov    %eax,(%esp)
80104825:	e8 a4 c7 ff ff       	call   80100fce <fileclose>
      proc->ofile[fd] = 0;
8010482a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104830:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104833:	83 c2 08             	add    $0x8,%edx
80104836:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010483d:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010483e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104842:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104846:	7e b6                	jle    801047fe <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104848:	e8 54 ec ff ff       	call   801034a1 <begin_op>
  iput(proc->cwd);
8010484d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104853:	8b 40 68             	mov    0x68(%eax),%eax
80104856:	89 04 24             	mov    %eax,(%esp)
80104859:	e8 14 d2 ff ff       	call   80101a72 <iput>
  end_op();
8010485e:	e8 c2 ec ff ff       	call   80103525 <end_op>
  proc->cwd = 0;
80104863:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104869:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104870:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104877:	e8 17 06 00 00       	call   80104e93 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010487c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104882:	8b 40 14             	mov    0x14(%eax),%eax
80104885:	89 04 24             	mov    %eax,(%esp)
80104888:	e8 cd 03 00 00       	call   80104c5a <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488d:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104894:	eb 38                	jmp    801048ce <exit+0xfb>
    if(p->parent == proc){
80104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104899:	8b 50 14             	mov    0x14(%eax),%edx
8010489c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a2:	39 c2                	cmp    %eax,%edx
801048a4:	75 24                	jne    801048ca <exit+0xf7>
      p->parent = initproc;
801048a6:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048af:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b5:	8b 40 0c             	mov    0xc(%eax),%eax
801048b8:	83 f8 05             	cmp    $0x5,%eax
801048bb:	75 0d                	jne    801048ca <exit+0xf7>
        wakeup1(initproc);
801048bd:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801048c2:	89 04 24             	mov    %eax,(%esp)
801048c5:	e8 90 03 00 00       	call   80104c5a <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ca:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801048ce:	81 7d f4 b4 48 11 80 	cmpl   $0x801148b4,-0xc(%ebp)
801048d5:	72 bf                	jb     80104896 <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801048d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048dd:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801048e4:	e8 b3 01 00 00       	call   80104a9c <sched>
  panic("zombie exit");
801048e9:	c7 04 24 05 88 10 80 	movl   $0x80108805,(%esp)
801048f0:	e8 45 bc ff ff       	call   8010053a <panic>

801048f5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801048f5:	55                   	push   %ebp
801048f6:	89 e5                	mov    %esp,%ebp
801048f8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801048fb:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104902:	e8 8c 05 00 00       	call   80104e93 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104907:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010490e:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104915:	e9 9a 00 00 00       	jmp    801049b4 <wait+0xbf>
      if(p->parent != proc)
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	8b 50 14             	mov    0x14(%eax),%edx
80104920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104926:	39 c2                	cmp    %eax,%edx
80104928:	74 05                	je     8010492f <wait+0x3a>
        continue;
8010492a:	e9 81 00 00 00       	jmp    801049b0 <wait+0xbb>
      havekids = 1;
8010492f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104939:	8b 40 0c             	mov    0xc(%eax),%eax
8010493c:	83 f8 05             	cmp    $0x5,%eax
8010493f:	75 6f                	jne    801049b0 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104944:	8b 40 10             	mov    0x10(%eax),%eax
80104947:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010494a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494d:	8b 40 08             	mov    0x8(%eax),%eax
80104950:	89 04 24             	mov    %eax,(%esp)
80104953:	e8 8c e1 ff ff       	call   80102ae4 <kfree>
        p->kstack = 0;
80104958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104965:	8b 40 04             	mov    0x4(%eax),%eax
80104968:	89 04 24             	mov    %eax,(%esp)
8010496b:	e8 18 38 00 00       	call   80108188 <freevm>
        p->state = UNUSED;
80104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104973:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010497a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010498e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104991:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104998:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010499f:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801049a6:	e8 4a 05 00 00       	call   80104ef5 <release>
        return pid;
801049ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ae:	eb 52                	jmp    80104a02 <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b0:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801049b4:	81 7d f4 b4 48 11 80 	cmpl   $0x801148b4,-0xc(%ebp)
801049bb:	0f 82 59 ff ff ff    	jb     8010491a <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801049c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801049c5:	74 0d                	je     801049d4 <wait+0xdf>
801049c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cd:	8b 40 24             	mov    0x24(%eax),%eax
801049d0:	85 c0                	test   %eax,%eax
801049d2:	74 13                	je     801049e7 <wait+0xf2>
      release(&ptable.lock);
801049d4:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801049db:	e8 15 05 00 00       	call   80104ef5 <release>
      return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e5:	eb 1b                	jmp    80104a02 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801049e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ed:	c7 44 24 04 80 29 11 	movl   $0x80112980,0x4(%esp)
801049f4:	80 
801049f5:	89 04 24             	mov    %eax,(%esp)
801049f8:	e8 c2 01 00 00       	call   80104bbf <sleep>
  }
801049fd:	e9 05 ff ff ff       	jmp    80104907 <wait+0x12>
}
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    

80104a04 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a0a:	e8 63 f9 ff ff       	call   80104372 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a0f:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104a16:	e8 78 04 00 00       	call   80104e93 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a1b:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104a22:	eb 5e                	jmp    80104a82 <scheduler+0x7e>
      if(p->state != RUNNABLE)
80104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a27:	8b 40 0c             	mov    0xc(%eax),%eax
80104a2a:	83 f8 03             	cmp    $0x3,%eax
80104a2d:	74 02                	je     80104a31 <scheduler+0x2d>
        continue;
80104a2f:	eb 4d                	jmp    80104a7e <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a34:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3d:	89 04 24             	mov    %eax,(%esp)
80104a40:	e8 d0 32 00 00       	call   80107d15 <switchuvm>
      p->state = RUNNING;
80104a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a48:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a55:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a58:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a5f:	83 c2 04             	add    $0x4,%edx
80104a62:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a66:	89 14 24             	mov    %edx,(%esp)
80104a69:	e8 14 09 00 00       	call   80105382 <swtch>
      switchkvm();
80104a6e:	e8 85 32 00 00       	call   80107cf8 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104a73:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104a7a:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a7e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a82:	81 7d f4 b4 48 11 80 	cmpl   $0x801148b4,-0xc(%ebp)
80104a89:	72 99                	jb     80104a24 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104a8b:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104a92:	e8 5e 04 00 00       	call   80104ef5 <release>

  }
80104a97:	e9 6e ff ff ff       	jmp    80104a0a <scheduler+0x6>

80104a9c <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104a9c:	55                   	push   %ebp
80104a9d:	89 e5                	mov    %esp,%ebp
80104a9f:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104aa2:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104aa9:	e8 0f 05 00 00       	call   80104fbd <holding>
80104aae:	85 c0                	test   %eax,%eax
80104ab0:	75 0c                	jne    80104abe <sched+0x22>
    panic("sched ptable.lock");
80104ab2:	c7 04 24 11 88 10 80 	movl   $0x80108811,(%esp)
80104ab9:	e8 7c ba ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104abe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ac4:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104aca:	83 f8 01             	cmp    $0x1,%eax
80104acd:	74 0c                	je     80104adb <sched+0x3f>
    panic("sched locks");
80104acf:	c7 04 24 23 88 10 80 	movl   $0x80108823,(%esp)
80104ad6:	e8 5f ba ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae4:	83 f8 04             	cmp    $0x4,%eax
80104ae7:	75 0c                	jne    80104af5 <sched+0x59>
    panic("sched running");
80104ae9:	c7 04 24 2f 88 10 80 	movl   $0x8010882f,(%esp)
80104af0:	e8 45 ba ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104af5:	e8 68 f8 ff ff       	call   80104362 <readeflags>
80104afa:	25 00 02 00 00       	and    $0x200,%eax
80104aff:	85 c0                	test   %eax,%eax
80104b01:	74 0c                	je     80104b0f <sched+0x73>
    panic("sched interruptible");
80104b03:	c7 04 24 3d 88 10 80 	movl   $0x8010883d,(%esp)
80104b0a:	e8 2b ba ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104b0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b15:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104b1e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b24:	8b 40 04             	mov    0x4(%eax),%eax
80104b27:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b2e:	83 c2 1c             	add    $0x1c,%edx
80104b31:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b35:	89 14 24             	mov    %edx,(%esp)
80104b38:	e8 45 08 00 00       	call   80105382 <swtch>
  cpu->intena = intena;
80104b3d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b46:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104b4c:	c9                   	leave  
80104b4d:	c3                   	ret    

80104b4e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104b4e:	55                   	push   %ebp
80104b4f:	89 e5                	mov    %esp,%ebp
80104b51:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104b54:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104b5b:	e8 33 03 00 00       	call   80104e93 <acquire>
  proc->state = RUNNABLE;
80104b60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b66:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104b6d:	e8 2a ff ff ff       	call   80104a9c <sched>
  release(&ptable.lock);
80104b72:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104b79:	e8 77 03 00 00       	call   80104ef5 <release>
}
80104b7e:	c9                   	leave  
80104b7f:	c3                   	ret    

80104b80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b86:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104b8d:	e8 63 03 00 00       	call   80104ef5 <release>

  if (first) {
80104b92:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
80104b97:	85 c0                	test   %eax,%eax
80104b99:	74 22                	je     80104bbd <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104b9b:	c7 05 0c b0 10 80 00 	movl   $0x0,0x8010b00c
80104ba2:	00 00 00 
    iinit(ROOTDEV);
80104ba5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bac:	e8 e0 c9 ff ff       	call   80101591 <iinit>
    initlog(ROOTDEV);
80104bb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bb8:	e8 e0 e6 ff ff       	call   8010329d <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104bbd:	c9                   	leave  
80104bbe:	c3                   	ret    

80104bbf <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104bbf:	55                   	push   %ebp
80104bc0:	89 e5                	mov    %esp,%ebp
80104bc2:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104bc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bcb:	85 c0                	test   %eax,%eax
80104bcd:	75 0c                	jne    80104bdb <sleep+0x1c>
    panic("sleep");
80104bcf:	c7 04 24 51 88 10 80 	movl   $0x80108851,(%esp)
80104bd6:	e8 5f b9 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104bdf:	75 0c                	jne    80104bed <sleep+0x2e>
    panic("sleep without lk");
80104be1:	c7 04 24 57 88 10 80 	movl   $0x80108857,(%esp)
80104be8:	e8 4d b9 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104bed:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104bf4:	74 17                	je     80104c0d <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104bf6:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104bfd:	e8 91 02 00 00       	call   80104e93 <acquire>
    release(lk);
80104c02:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c05:	89 04 24             	mov    %eax,(%esp)
80104c08:	e8 e8 02 00 00       	call   80104ef5 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104c0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c13:	8b 55 08             	mov    0x8(%ebp),%edx
80104c16:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104c19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104c26:	e8 71 fe ff ff       	call   80104a9c <sched>

  // Tidy up.
  proc->chan = 0;
80104c2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c31:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c38:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104c3f:	74 17                	je     80104c58 <sleep+0x99>
    release(&ptable.lock);
80104c41:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104c48:	e8 a8 02 00 00       	call   80104ef5 <release>
    acquire(lk);
80104c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c50:	89 04 24             	mov    %eax,(%esp)
80104c53:	e8 3b 02 00 00       	call   80104e93 <acquire>
  }
}
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    

80104c5a <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104c5a:	55                   	push   %ebp
80104c5b:	89 e5                	mov    %esp,%ebp
80104c5d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c60:	c7 45 fc b4 29 11 80 	movl   $0x801129b4,-0x4(%ebp)
80104c67:	eb 24                	jmp    80104c8d <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c6c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c6f:	83 f8 02             	cmp    $0x2,%eax
80104c72:	75 15                	jne    80104c89 <wakeup1+0x2f>
80104c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c77:	8b 40 20             	mov    0x20(%eax),%eax
80104c7a:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c7d:	75 0a                	jne    80104c89 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c82:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c89:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104c8d:	81 7d fc b4 48 11 80 	cmpl   $0x801148b4,-0x4(%ebp)
80104c94:	72 d3                	jb     80104c69 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104c96:	c9                   	leave  
80104c97:	c3                   	ret    

80104c98 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c98:	55                   	push   %ebp
80104c99:	89 e5                	mov    %esp,%ebp
80104c9b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104c9e:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104ca5:	e8 e9 01 00 00       	call   80104e93 <acquire>
  wakeup1(chan);
80104caa:	8b 45 08             	mov    0x8(%ebp),%eax
80104cad:	89 04 24             	mov    %eax,(%esp)
80104cb0:	e8 a5 ff ff ff       	call   80104c5a <wakeup1>
  release(&ptable.lock);
80104cb5:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104cbc:	e8 34 02 00 00       	call   80104ef5 <release>
}
80104cc1:	c9                   	leave  
80104cc2:	c3                   	ret    

80104cc3 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104cc3:	55                   	push   %ebp
80104cc4:	89 e5                	mov    %esp,%ebp
80104cc6:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104cc9:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104cd0:	e8 be 01 00 00       	call   80104e93 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd5:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104cdc:	eb 41                	jmp    80104d1f <kill+0x5c>
    if(p->pid == pid){
80104cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce1:	8b 40 10             	mov    0x10(%eax),%eax
80104ce4:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ce7:	75 32                	jne    80104d1b <kill+0x58>
      p->killed = 1;
80104ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cec:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf6:	8b 40 0c             	mov    0xc(%eax),%eax
80104cf9:	83 f8 02             	cmp    $0x2,%eax
80104cfc:	75 0a                	jne    80104d08 <kill+0x45>
        p->state = RUNNABLE;
80104cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d01:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d08:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104d0f:	e8 e1 01 00 00       	call   80104ef5 <release>
      return 0;
80104d14:	b8 00 00 00 00       	mov    $0x0,%eax
80104d19:	eb 1e                	jmp    80104d39 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d1b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104d1f:	81 7d f4 b4 48 11 80 	cmpl   $0x801148b4,-0xc(%ebp)
80104d26:	72 b6                	jb     80104cde <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104d28:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104d2f:	e8 c1 01 00 00       	call   80104ef5 <release>
  return -1;
80104d34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d39:	c9                   	leave  
80104d3a:	c3                   	ret    

80104d3b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d3b:	55                   	push   %ebp
80104d3c:	89 e5                	mov    %esp,%ebp
80104d3e:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d41:	c7 45 f0 b4 29 11 80 	movl   $0x801129b4,-0x10(%ebp)
80104d48:	e9 d6 00 00 00       	jmp    80104e23 <procdump+0xe8>
    if(p->state == UNUSED)
80104d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d50:	8b 40 0c             	mov    0xc(%eax),%eax
80104d53:	85 c0                	test   %eax,%eax
80104d55:	75 05                	jne    80104d5c <procdump+0x21>
      continue;
80104d57:	e9 c3 00 00 00       	jmp    80104e1f <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5f:	8b 40 0c             	mov    0xc(%eax),%eax
80104d62:	83 f8 05             	cmp    $0x5,%eax
80104d65:	77 23                	ja     80104d8a <procdump+0x4f>
80104d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d6a:	8b 40 0c             	mov    0xc(%eax),%eax
80104d6d:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80104d74:	85 c0                	test   %eax,%eax
80104d76:	74 12                	je     80104d8a <procdump+0x4f>
      state = states[p->state];
80104d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d7b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d7e:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80104d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d88:	eb 07                	jmp    80104d91 <procdump+0x56>
    else
      state = "???";
80104d8a:	c7 45 ec 68 88 10 80 	movl   $0x80108868,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d94:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d9a:	8b 40 10             	mov    0x10(%eax),%eax
80104d9d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104da1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104da4:	89 54 24 08          	mov    %edx,0x8(%esp)
80104da8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dac:	c7 04 24 6c 88 10 80 	movl   $0x8010886c,(%esp)
80104db3:	e8 e8 b5 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dbb:	8b 40 0c             	mov    0xc(%eax),%eax
80104dbe:	83 f8 02             	cmp    $0x2,%eax
80104dc1:	75 50                	jne    80104e13 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dc6:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dc9:	8b 40 0c             	mov    0xc(%eax),%eax
80104dcc:	83 c0 08             	add    $0x8,%eax
80104dcf:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
80104dd6:	89 04 24             	mov    %eax,(%esp)
80104dd9:	e8 66 01 00 00       	call   80104f44 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104de5:	eb 1b                	jmp    80104e02 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dea:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104dee:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df2:	c7 04 24 75 88 10 80 	movl   $0x80108875,(%esp)
80104df9:	e8 a2 b5 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104dfe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e02:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e06:	7f 0b                	jg     80104e13 <procdump+0xd8>
80104e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0b:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e0f:	85 c0                	test   %eax,%eax
80104e11:	75 d4                	jne    80104de7 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e13:	c7 04 24 79 88 10 80 	movl   $0x80108879,(%esp)
80104e1a:	e8 81 b5 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e1f:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104e23:	81 7d f0 b4 48 11 80 	cmpl   $0x801148b4,-0x10(%ebp)
80104e2a:	0f 82 1d ff ff ff    	jb     80104d4d <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    

80104e32 <getuser>:

int
getuser(void){
80104e32:	55                   	push   %ebp
80104e33:	89 e5                	mov    %esp,%ebp
	return CURRENT_USER;
80104e35:	a1 04 b0 10 80       	mov    0x8010b004,%eax
}
80104e3a:	5d                   	pop    %ebp
80104e3b:	c3                   	ret    

80104e3c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104e3c:	55                   	push   %ebp
80104e3d:	89 e5                	mov    %esp,%ebp
80104e3f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e42:	9c                   	pushf  
80104e43:	58                   	pop    %eax
80104e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    

80104e4c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104e4c:	55                   	push   %ebp
80104e4d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104e4f:	fa                   	cli    
}
80104e50:	5d                   	pop    %ebp
80104e51:	c3                   	ret    

80104e52 <sti>:

static inline void
sti(void)
{
80104e52:	55                   	push   %ebp
80104e53:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104e55:	fb                   	sti    
}
80104e56:	5d                   	pop    %ebp
80104e57:	c3                   	ret    

80104e58 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104e58:	55                   	push   %ebp
80104e59:	89 e5                	mov    %esp,%ebp
80104e5b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80104e61:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e67:	f0 87 02             	lock xchg %eax,(%edx)
80104e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e70:	c9                   	leave  
80104e71:	c3                   	ret    

80104e72 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e72:	55                   	push   %ebp
80104e73:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104e75:	8b 45 08             	mov    0x8(%ebp),%eax
80104e78:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e7b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104e87:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    

80104e93 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104e93:	55                   	push   %ebp
80104e94:	89 e5                	mov    %esp,%ebp
80104e96:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e99:	e8 49 01 00 00       	call   80104fe7 <pushcli>
  if(holding(lk))
80104e9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea1:	89 04 24             	mov    %eax,(%esp)
80104ea4:	e8 14 01 00 00       	call   80104fbd <holding>
80104ea9:	85 c0                	test   %eax,%eax
80104eab:	74 0c                	je     80104eb9 <acquire+0x26>
    panic("acquire");
80104ead:	c7 04 24 a5 88 10 80 	movl   $0x801088a5,(%esp)
80104eb4:	e8 81 b6 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104eb9:	90                   	nop
80104eba:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104ec4:	00 
80104ec5:	89 04 24             	mov    %eax,(%esp)
80104ec8:	e8 8b ff ff ff       	call   80104e58 <xchg>
80104ecd:	85 c0                	test   %eax,%eax
80104ecf:	75 e9                	jne    80104eba <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104edb:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104ede:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee1:	83 c0 0c             	add    $0xc,%eax
80104ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ee8:	8d 45 08             	lea    0x8(%ebp),%eax
80104eeb:	89 04 24             	mov    %eax,(%esp)
80104eee:	e8 51 00 00 00       	call   80104f44 <getcallerpcs>
}
80104ef3:	c9                   	leave  
80104ef4:	c3                   	ret    

80104ef5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104ef5:	55                   	push   %ebp
80104ef6:	89 e5                	mov    %esp,%ebp
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104efb:	8b 45 08             	mov    0x8(%ebp),%eax
80104efe:	89 04 24             	mov    %eax,(%esp)
80104f01:	e8 b7 00 00 00       	call   80104fbd <holding>
80104f06:	85 c0                	test   %eax,%eax
80104f08:	75 0c                	jne    80104f16 <release+0x21>
    panic("release");
80104f0a:	c7 04 24 ad 88 10 80 	movl   $0x801088ad,(%esp)
80104f11:	e8 24 b6 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104f16:	8b 45 08             	mov    0x8(%ebp),%eax
80104f19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104f20:	8b 45 08             	mov    0x8(%ebp),%eax
80104f23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104f34:	00 
80104f35:	89 04 24             	mov    %eax,(%esp)
80104f38:	e8 1b ff ff ff       	call   80104e58 <xchg>

  popcli();
80104f3d:	e8 e9 00 00 00       	call   8010502b <popcli>
}
80104f42:	c9                   	leave  
80104f43:	c3                   	ret    

80104f44 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4d:	83 e8 08             	sub    $0x8,%eax
80104f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104f5a:	eb 38                	jmp    80104f94 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104f60:	74 38                	je     80104f9a <getcallerpcs+0x56>
80104f62:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104f69:	76 2f                	jbe    80104f9a <getcallerpcs+0x56>
80104f6b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104f6f:	74 29                	je     80104f9a <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f71:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7e:	01 c2                	add    %eax,%edx
80104f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f83:	8b 40 04             	mov    0x4(%eax),%eax
80104f86:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f8b:	8b 00                	mov    (%eax),%eax
80104f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f90:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f94:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104f98:	7e c2                	jle    80104f5c <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104f9a:	eb 19                	jmp    80104fb5 <getcallerpcs+0x71>
    pcs[i] = 0;
80104f9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fa9:	01 d0                	add    %edx,%eax
80104fab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104fb1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fb5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104fb9:	7e e1                	jle    80104f9c <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104fbb:	c9                   	leave  
80104fbc:	c3                   	ret    

80104fbd <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104fbd:	55                   	push   %ebp
80104fbe:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc3:	8b 00                	mov    (%eax),%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	74 17                	je     80104fe0 <holding+0x23>
80104fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcc:	8b 50 08             	mov    0x8(%eax),%edx
80104fcf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fd5:	39 c2                	cmp    %eax,%edx
80104fd7:	75 07                	jne    80104fe0 <holding+0x23>
80104fd9:	b8 01 00 00 00       	mov    $0x1,%eax
80104fde:	eb 05                	jmp    80104fe5 <holding+0x28>
80104fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fe5:	5d                   	pop    %ebp
80104fe6:	c3                   	ret    

80104fe7 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fe7:	55                   	push   %ebp
80104fe8:	89 e5                	mov    %esp,%ebp
80104fea:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104fed:	e8 4a fe ff ff       	call   80104e3c <readeflags>
80104ff2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104ff5:	e8 52 fe ff ff       	call   80104e4c <cli>
  if(cpu->ncli++ == 0)
80104ffa:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105001:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105007:	8d 48 01             	lea    0x1(%eax),%ecx
8010500a:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105010:	85 c0                	test   %eax,%eax
80105012:	75 15                	jne    80105029 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105014:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010501a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010501d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105023:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105029:	c9                   	leave  
8010502a:	c3                   	ret    

8010502b <popcli>:

void
popcli(void)
{
8010502b:	55                   	push   %ebp
8010502c:	89 e5                	mov    %esp,%ebp
8010502e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105031:	e8 06 fe ff ff       	call   80104e3c <readeflags>
80105036:	25 00 02 00 00       	and    $0x200,%eax
8010503b:	85 c0                	test   %eax,%eax
8010503d:	74 0c                	je     8010504b <popcli+0x20>
    panic("popcli - interruptible");
8010503f:	c7 04 24 b5 88 10 80 	movl   $0x801088b5,(%esp)
80105046:	e8 ef b4 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
8010504b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105051:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105057:	83 ea 01             	sub    $0x1,%edx
8010505a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105060:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105066:	85 c0                	test   %eax,%eax
80105068:	79 0c                	jns    80105076 <popcli+0x4b>
    panic("popcli");
8010506a:	c7 04 24 cc 88 10 80 	movl   $0x801088cc,(%esp)
80105071:	e8 c4 b4 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105076:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010507c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105082:	85 c0                	test   %eax,%eax
80105084:	75 15                	jne    8010509b <popcli+0x70>
80105086:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010508c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105092:	85 c0                	test   %eax,%eax
80105094:	74 05                	je     8010509b <popcli+0x70>
    sti();
80105096:	e8 b7 fd ff ff       	call   80104e52 <sti>
}
8010509b:	c9                   	leave  
8010509c:	c3                   	ret    

8010509d <checkUserLevel>:
#include "user.h"



int
checkUserLevel(void){
8010509d:	55                   	push   %ebp
8010509e:	89 e5                	mov    %esp,%ebp
  return 1;
801050a0:	b8 01 00 00 00       	mov    $0x1,%eax
}
801050a5:	5d                   	pop    %ebp
801050a6:	c3                   	ret    

801050a7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801050a7:	55                   	push   %ebp
801050a8:	89 e5                	mov    %esp,%ebp
801050aa:	57                   	push   %edi
801050ab:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801050ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050af:	8b 55 10             	mov    0x10(%ebp),%edx
801050b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b5:	89 cb                	mov    %ecx,%ebx
801050b7:	89 df                	mov    %ebx,%edi
801050b9:	89 d1                	mov    %edx,%ecx
801050bb:	fc                   	cld    
801050bc:	f3 aa                	rep stos %al,%es:(%edi)
801050be:	89 ca                	mov    %ecx,%edx
801050c0:	89 fb                	mov    %edi,%ebx
801050c2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801050c5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801050c8:	5b                   	pop    %ebx
801050c9:	5f                   	pop    %edi
801050ca:	5d                   	pop    %ebp
801050cb:	c3                   	ret    

801050cc <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801050cc:	55                   	push   %ebp
801050cd:	89 e5                	mov    %esp,%ebp
801050cf:	57                   	push   %edi
801050d0:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801050d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050d4:	8b 55 10             	mov    0x10(%ebp),%edx
801050d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801050da:	89 cb                	mov    %ecx,%ebx
801050dc:	89 df                	mov    %ebx,%edi
801050de:	89 d1                	mov    %edx,%ecx
801050e0:	fc                   	cld    
801050e1:	f3 ab                	rep stos %eax,%es:(%edi)
801050e3:	89 ca                	mov    %ecx,%edx
801050e5:	89 fb                	mov    %edi,%ebx
801050e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801050ea:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801050ed:	5b                   	pop    %ebx
801050ee:	5f                   	pop    %edi
801050ef:	5d                   	pop    %ebp
801050f0:	c3                   	ret    

801050f1 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801050f1:	55                   	push   %ebp
801050f2:	89 e5                	mov    %esp,%ebp
801050f4:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801050f7:	8b 45 08             	mov    0x8(%ebp),%eax
801050fa:	83 e0 03             	and    $0x3,%eax
801050fd:	85 c0                	test   %eax,%eax
801050ff:	75 49                	jne    8010514a <memset+0x59>
80105101:	8b 45 10             	mov    0x10(%ebp),%eax
80105104:	83 e0 03             	and    $0x3,%eax
80105107:	85 c0                	test   %eax,%eax
80105109:	75 3f                	jne    8010514a <memset+0x59>
    c &= 0xFF;
8010510b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105112:	8b 45 10             	mov    0x10(%ebp),%eax
80105115:	c1 e8 02             	shr    $0x2,%eax
80105118:	89 c2                	mov    %eax,%edx
8010511a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010511d:	c1 e0 18             	shl    $0x18,%eax
80105120:	89 c1                	mov    %eax,%ecx
80105122:	8b 45 0c             	mov    0xc(%ebp),%eax
80105125:	c1 e0 10             	shl    $0x10,%eax
80105128:	09 c1                	or     %eax,%ecx
8010512a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010512d:	c1 e0 08             	shl    $0x8,%eax
80105130:	09 c8                	or     %ecx,%eax
80105132:	0b 45 0c             	or     0xc(%ebp),%eax
80105135:	89 54 24 08          	mov    %edx,0x8(%esp)
80105139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010513d:	8b 45 08             	mov    0x8(%ebp),%eax
80105140:	89 04 24             	mov    %eax,(%esp)
80105143:	e8 84 ff ff ff       	call   801050cc <stosl>
80105148:	eb 19                	jmp    80105163 <memset+0x72>
  } else
    stosb(dst, c, n);
8010514a:	8b 45 10             	mov    0x10(%ebp),%eax
8010514d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105151:	8b 45 0c             	mov    0xc(%ebp),%eax
80105154:	89 44 24 04          	mov    %eax,0x4(%esp)
80105158:	8b 45 08             	mov    0x8(%ebp),%eax
8010515b:	89 04 24             	mov    %eax,(%esp)
8010515e:	e8 44 ff ff ff       	call   801050a7 <stosb>
  return dst;
80105163:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105166:	c9                   	leave  
80105167:	c3                   	ret    

80105168 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105168:	55                   	push   %ebp
80105169:	89 e5                	mov    %esp,%ebp
8010516b:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010516e:	8b 45 08             	mov    0x8(%ebp),%eax
80105171:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105174:	8b 45 0c             	mov    0xc(%ebp),%eax
80105177:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010517a:	eb 30                	jmp    801051ac <memcmp+0x44>
    if(*s1 != *s2)
8010517c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010517f:	0f b6 10             	movzbl (%eax),%edx
80105182:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105185:	0f b6 00             	movzbl (%eax),%eax
80105188:	38 c2                	cmp    %al,%dl
8010518a:	74 18                	je     801051a4 <memcmp+0x3c>
      return *s1 - *s2;
8010518c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010518f:	0f b6 00             	movzbl (%eax),%eax
80105192:	0f b6 d0             	movzbl %al,%edx
80105195:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105198:	0f b6 00             	movzbl (%eax),%eax
8010519b:	0f b6 c0             	movzbl %al,%eax
8010519e:	29 c2                	sub    %eax,%edx
801051a0:	89 d0                	mov    %edx,%eax
801051a2:	eb 1a                	jmp    801051be <memcmp+0x56>
    s1++, s2++;
801051a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051a8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051ac:	8b 45 10             	mov    0x10(%ebp),%eax
801051af:	8d 50 ff             	lea    -0x1(%eax),%edx
801051b2:	89 55 10             	mov    %edx,0x10(%ebp)
801051b5:	85 c0                	test   %eax,%eax
801051b7:	75 c3                	jne    8010517c <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801051b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051be:	c9                   	leave  
801051bf:	c3                   	ret    

801051c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801051c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801051cc:	8b 45 08             	mov    0x8(%ebp),%eax
801051cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801051d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051d8:	73 3d                	jae    80105217 <memmove+0x57>
801051da:	8b 45 10             	mov    0x10(%ebp),%eax
801051dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051e0:	01 d0                	add    %edx,%eax
801051e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801051e5:	76 30                	jbe    80105217 <memmove+0x57>
    s += n;
801051e7:	8b 45 10             	mov    0x10(%ebp),%eax
801051ea:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801051ed:	8b 45 10             	mov    0x10(%ebp),%eax
801051f0:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801051f3:	eb 13                	jmp    80105208 <memmove+0x48>
      *--d = *--s;
801051f5:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801051f9:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801051fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105200:	0f b6 10             	movzbl (%eax),%edx
80105203:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105206:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105208:	8b 45 10             	mov    0x10(%ebp),%eax
8010520b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010520e:	89 55 10             	mov    %edx,0x10(%ebp)
80105211:	85 c0                	test   %eax,%eax
80105213:	75 e0                	jne    801051f5 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105215:	eb 26                	jmp    8010523d <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105217:	eb 17                	jmp    80105230 <memmove+0x70>
      *d++ = *s++;
80105219:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010521c:	8d 50 01             	lea    0x1(%eax),%edx
8010521f:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105222:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105225:	8d 4a 01             	lea    0x1(%edx),%ecx
80105228:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010522b:	0f b6 12             	movzbl (%edx),%edx
8010522e:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105230:	8b 45 10             	mov    0x10(%ebp),%eax
80105233:	8d 50 ff             	lea    -0x1(%eax),%edx
80105236:	89 55 10             	mov    %edx,0x10(%ebp)
80105239:	85 c0                	test   %eax,%eax
8010523b:	75 dc                	jne    80105219 <memmove+0x59>
      *d++ = *s++;

  return dst;
8010523d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105240:	c9                   	leave  
80105241:	c3                   	ret    

80105242 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105242:	55                   	push   %ebp
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105248:	8b 45 10             	mov    0x10(%ebp),%eax
8010524b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010524f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105252:	89 44 24 04          	mov    %eax,0x4(%esp)
80105256:	8b 45 08             	mov    0x8(%ebp),%eax
80105259:	89 04 24             	mov    %eax,(%esp)
8010525c:	e8 5f ff ff ff       	call   801051c0 <memmove>
}
80105261:	c9                   	leave  
80105262:	c3                   	ret    

80105263 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105263:	55                   	push   %ebp
80105264:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105266:	eb 0c                	jmp    80105274 <strncmp+0x11>
    n--, p++, q++;
80105268:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010526c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105270:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105278:	74 1a                	je     80105294 <strncmp+0x31>
8010527a:	8b 45 08             	mov    0x8(%ebp),%eax
8010527d:	0f b6 00             	movzbl (%eax),%eax
80105280:	84 c0                	test   %al,%al
80105282:	74 10                	je     80105294 <strncmp+0x31>
80105284:	8b 45 08             	mov    0x8(%ebp),%eax
80105287:	0f b6 10             	movzbl (%eax),%edx
8010528a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528d:	0f b6 00             	movzbl (%eax),%eax
80105290:	38 c2                	cmp    %al,%dl
80105292:	74 d4                	je     80105268 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105298:	75 07                	jne    801052a1 <strncmp+0x3e>
    return 0;
8010529a:	b8 00 00 00 00       	mov    $0x0,%eax
8010529f:	eb 16                	jmp    801052b7 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801052a1:	8b 45 08             	mov    0x8(%ebp),%eax
801052a4:	0f b6 00             	movzbl (%eax),%eax
801052a7:	0f b6 d0             	movzbl %al,%edx
801052aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ad:	0f b6 00             	movzbl (%eax),%eax
801052b0:	0f b6 c0             	movzbl %al,%eax
801052b3:	29 c2                	sub    %eax,%edx
801052b5:	89 d0                	mov    %edx,%eax
}
801052b7:	5d                   	pop    %ebp
801052b8:	c3                   	ret    

801052b9 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052b9:	55                   	push   %ebp
801052ba:	89 e5                	mov    %esp,%ebp
801052bc:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801052bf:	8b 45 08             	mov    0x8(%ebp),%eax
801052c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801052c5:	90                   	nop
801052c6:	8b 45 10             	mov    0x10(%ebp),%eax
801052c9:	8d 50 ff             	lea    -0x1(%eax),%edx
801052cc:	89 55 10             	mov    %edx,0x10(%ebp)
801052cf:	85 c0                	test   %eax,%eax
801052d1:	7e 1e                	jle    801052f1 <strncpy+0x38>
801052d3:	8b 45 08             	mov    0x8(%ebp),%eax
801052d6:	8d 50 01             	lea    0x1(%eax),%edx
801052d9:	89 55 08             	mov    %edx,0x8(%ebp)
801052dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801052df:	8d 4a 01             	lea    0x1(%edx),%ecx
801052e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801052e5:	0f b6 12             	movzbl (%edx),%edx
801052e8:	88 10                	mov    %dl,(%eax)
801052ea:	0f b6 00             	movzbl (%eax),%eax
801052ed:	84 c0                	test   %al,%al
801052ef:	75 d5                	jne    801052c6 <strncpy+0xd>
    ;
  while(n-- > 0)
801052f1:	eb 0c                	jmp    801052ff <strncpy+0x46>
    *s++ = 0;
801052f3:	8b 45 08             	mov    0x8(%ebp),%eax
801052f6:	8d 50 01             	lea    0x1(%eax),%edx
801052f9:	89 55 08             	mov    %edx,0x8(%ebp)
801052fc:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801052ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105302:	8d 50 ff             	lea    -0x1(%eax),%edx
80105305:	89 55 10             	mov    %edx,0x10(%ebp)
80105308:	85 c0                	test   %eax,%eax
8010530a:	7f e7                	jg     801052f3 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010530c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010530f:	c9                   	leave  
80105310:	c3                   	ret    

80105311 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105311:	55                   	push   %ebp
80105312:	89 e5                	mov    %esp,%ebp
80105314:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105317:	8b 45 08             	mov    0x8(%ebp),%eax
8010531a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010531d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105321:	7f 05                	jg     80105328 <safestrcpy+0x17>
    return os;
80105323:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105326:	eb 31                	jmp    80105359 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105328:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010532c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105330:	7e 1e                	jle    80105350 <safestrcpy+0x3f>
80105332:	8b 45 08             	mov    0x8(%ebp),%eax
80105335:	8d 50 01             	lea    0x1(%eax),%edx
80105338:	89 55 08             	mov    %edx,0x8(%ebp)
8010533b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010533e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105341:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105344:	0f b6 12             	movzbl (%edx),%edx
80105347:	88 10                	mov    %dl,(%eax)
80105349:	0f b6 00             	movzbl (%eax),%eax
8010534c:	84 c0                	test   %al,%al
8010534e:	75 d8                	jne    80105328 <safestrcpy+0x17>
    ;
  *s = 0;
80105350:	8b 45 08             	mov    0x8(%ebp),%eax
80105353:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105359:	c9                   	leave  
8010535a:	c3                   	ret    

8010535b <strlen>:

int
strlen(const char *s)
{
8010535b:	55                   	push   %ebp
8010535c:	89 e5                	mov    %esp,%ebp
8010535e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105361:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105368:	eb 04                	jmp    8010536e <strlen+0x13>
8010536a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010536e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105371:	8b 45 08             	mov    0x8(%ebp),%eax
80105374:	01 d0                	add    %edx,%eax
80105376:	0f b6 00             	movzbl (%eax),%eax
80105379:	84 c0                	test   %al,%al
8010537b:	75 ed                	jne    8010536a <strlen+0xf>
    ;
  return n;
8010537d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105380:	c9                   	leave  
80105381:	c3                   	ret    

80105382 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105382:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105386:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010538a:	55                   	push   %ebp
  pushl %ebx
8010538b:	53                   	push   %ebx
  pushl %esi
8010538c:	56                   	push   %esi
  pushl %edi
8010538d:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010538e:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105390:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105392:	5f                   	pop    %edi
  popl %esi
80105393:	5e                   	pop    %esi
  popl %ebx
80105394:	5b                   	pop    %ebx
  popl %ebp
80105395:	5d                   	pop    %ebp
  ret
80105396:	c3                   	ret    

80105397 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105397:	55                   	push   %ebp
80105398:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010539a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053a0:	8b 00                	mov    (%eax),%eax
801053a2:	3b 45 08             	cmp    0x8(%ebp),%eax
801053a5:	76 12                	jbe    801053b9 <fetchint+0x22>
801053a7:	8b 45 08             	mov    0x8(%ebp),%eax
801053aa:	8d 50 04             	lea    0x4(%eax),%edx
801053ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b3:	8b 00                	mov    (%eax),%eax
801053b5:	39 c2                	cmp    %eax,%edx
801053b7:	76 07                	jbe    801053c0 <fetchint+0x29>
    return -1;
801053b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053be:	eb 0f                	jmp    801053cf <fetchint+0x38>
  *ip = *(int*)(addr);
801053c0:	8b 45 08             	mov    0x8(%ebp),%eax
801053c3:	8b 10                	mov    (%eax),%edx
801053c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c8:	89 10                	mov    %edx,(%eax)
  return 0;
801053ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053cf:	5d                   	pop    %ebp
801053d0:	c3                   	ret    

801053d1 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801053d1:	55                   	push   %ebp
801053d2:	89 e5                	mov    %esp,%ebp
801053d4:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801053d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053dd:	8b 00                	mov    (%eax),%eax
801053df:	3b 45 08             	cmp    0x8(%ebp),%eax
801053e2:	77 07                	ja     801053eb <fetchstr+0x1a>
    return -1;
801053e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e9:	eb 46                	jmp    80105431 <fetchstr+0x60>
  *pp = (char*)addr;
801053eb:	8b 55 08             	mov    0x8(%ebp),%edx
801053ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f1:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801053f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f9:	8b 00                	mov    (%eax),%eax
801053fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801053fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105401:	8b 00                	mov    (%eax),%eax
80105403:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105406:	eb 1c                	jmp    80105424 <fetchstr+0x53>
    if(*s == 0)
80105408:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010540b:	0f b6 00             	movzbl (%eax),%eax
8010540e:	84 c0                	test   %al,%al
80105410:	75 0e                	jne    80105420 <fetchstr+0x4f>
      return s - *pp;
80105412:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105415:	8b 45 0c             	mov    0xc(%ebp),%eax
80105418:	8b 00                	mov    (%eax),%eax
8010541a:	29 c2                	sub    %eax,%edx
8010541c:	89 d0                	mov    %edx,%eax
8010541e:	eb 11                	jmp    80105431 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105420:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105424:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105427:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010542a:	72 dc                	jb     80105408 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010542c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105431:	c9                   	leave  
80105432:	c3                   	ret    

80105433 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105433:	55                   	push   %ebp
80105434:	89 e5                	mov    %esp,%ebp
80105436:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105439:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010543f:	8b 40 18             	mov    0x18(%eax),%eax
80105442:	8b 50 44             	mov    0x44(%eax),%edx
80105445:	8b 45 08             	mov    0x8(%ebp),%eax
80105448:	c1 e0 02             	shl    $0x2,%eax
8010544b:	01 d0                	add    %edx,%eax
8010544d:	8d 50 04             	lea    0x4(%eax),%edx
80105450:	8b 45 0c             	mov    0xc(%ebp),%eax
80105453:	89 44 24 04          	mov    %eax,0x4(%esp)
80105457:	89 14 24             	mov    %edx,(%esp)
8010545a:	e8 38 ff ff ff       	call   80105397 <fetchint>
}
8010545f:	c9                   	leave  
80105460:	c3                   	ret    

80105461 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105461:	55                   	push   %ebp
80105462:	89 e5                	mov    %esp,%ebp
80105464:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105467:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010546a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546e:	8b 45 08             	mov    0x8(%ebp),%eax
80105471:	89 04 24             	mov    %eax,(%esp)
80105474:	e8 ba ff ff ff       	call   80105433 <argint>
80105479:	85 c0                	test   %eax,%eax
8010547b:	79 07                	jns    80105484 <argptr+0x23>
    return -1;
8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105482:	eb 3d                	jmp    801054c1 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105484:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105487:	89 c2                	mov    %eax,%edx
80105489:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010548f:	8b 00                	mov    (%eax),%eax
80105491:	39 c2                	cmp    %eax,%edx
80105493:	73 16                	jae    801054ab <argptr+0x4a>
80105495:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105498:	89 c2                	mov    %eax,%edx
8010549a:	8b 45 10             	mov    0x10(%ebp),%eax
8010549d:	01 c2                	add    %eax,%edx
8010549f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a5:	8b 00                	mov    (%eax),%eax
801054a7:	39 c2                	cmp    %eax,%edx
801054a9:	76 07                	jbe    801054b2 <argptr+0x51>
    return -1;
801054ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b0:	eb 0f                	jmp    801054c1 <argptr+0x60>
  *pp = (char*)i;
801054b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054b5:	89 c2                	mov    %eax,%edx
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	89 10                	mov    %edx,(%eax)
  return 0;
801054bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    

801054c3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054c3:	55                   	push   %ebp
801054c4:	89 e5                	mov    %esp,%ebp
801054c6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801054c9:	8d 45 fc             	lea    -0x4(%ebp),%eax
801054cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d0:	8b 45 08             	mov    0x8(%ebp),%eax
801054d3:	89 04 24             	mov    %eax,(%esp)
801054d6:	e8 58 ff ff ff       	call   80105433 <argint>
801054db:	85 c0                	test   %eax,%eax
801054dd:	79 07                	jns    801054e6 <argstr+0x23>
    return -1;
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e4:	eb 12                	jmp    801054f8 <argstr+0x35>
  return fetchstr(addr, pp);
801054e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801054ec:	89 54 24 04          	mov    %edx,0x4(%esp)
801054f0:	89 04 24             	mov    %eax,(%esp)
801054f3:	e8 d9 fe ff ff       	call   801053d1 <fetchstr>
}
801054f8:	c9                   	leave  
801054f9:	c3                   	ret    

801054fa <syscall>:
[SYS_setuser] sys_setuser,
};

void
syscall(void)
{
801054fa:	55                   	push   %ebp
801054fb:	89 e5                	mov    %esp,%ebp
801054fd:	53                   	push   %ebx
801054fe:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105501:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105507:	8b 40 18             	mov    0x18(%eax),%eax
8010550a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010550d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105514:	7e 30                	jle    80105546 <syscall+0x4c>
80105516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105519:	83 f8 17             	cmp    $0x17,%eax
8010551c:	77 28                	ja     80105546 <syscall+0x4c>
8010551e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105521:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105528:	85 c0                	test   %eax,%eax
8010552a:	74 1a                	je     80105546 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010552c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105532:	8b 58 18             	mov    0x18(%eax),%ebx
80105535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105538:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010553f:	ff d0                	call   *%eax
80105541:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105544:	eb 3d                	jmp    80105583 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010554c:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010554f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105555:	8b 40 10             	mov    0x10(%eax),%eax
80105558:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010555f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105563:	89 44 24 04          	mov    %eax,0x4(%esp)
80105567:	c7 04 24 d3 88 10 80 	movl   $0x801088d3,(%esp)
8010556e:	e8 2d ae ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105573:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105579:	8b 40 18             	mov    0x18(%eax),%eax
8010557c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105583:	83 c4 24             	add    $0x24,%esp
80105586:	5b                   	pop    %ebx
80105587:	5d                   	pop    %ebp
80105588:	c3                   	ret    

80105589 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105589:	55                   	push   %ebp
8010558a:	89 e5                	mov    %esp,%ebp
8010558c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010558f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105592:	89 44 24 04          	mov    %eax,0x4(%esp)
80105596:	8b 45 08             	mov    0x8(%ebp),%eax
80105599:	89 04 24             	mov    %eax,(%esp)
8010559c:	e8 92 fe ff ff       	call   80105433 <argint>
801055a1:	85 c0                	test   %eax,%eax
801055a3:	79 07                	jns    801055ac <argfd+0x23>
    return -1;
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	eb 50                	jmp    801055fc <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801055ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055af:	85 c0                	test   %eax,%eax
801055b1:	78 21                	js     801055d4 <argfd+0x4b>
801055b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b6:	83 f8 0f             	cmp    $0xf,%eax
801055b9:	7f 19                	jg     801055d4 <argfd+0x4b>
801055bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055c4:	83 c2 08             	add    $0x8,%edx
801055c7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801055cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055d2:	75 07                	jne    801055db <argfd+0x52>
    return -1;
801055d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d9:	eb 21                	jmp    801055fc <argfd+0x73>
  if(pfd)
801055db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055df:	74 08                	je     801055e9 <argfd+0x60>
    *pfd = fd;
801055e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e7:	89 10                	mov    %edx,(%eax)
  if(pf)
801055e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055ed:	74 08                	je     801055f7 <argfd+0x6e>
    *pf = f;
801055ef:	8b 45 10             	mov    0x10(%ebp),%eax
801055f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055f5:	89 10                	mov    %edx,(%eax)
  return 0;
801055f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055fc:	c9                   	leave  
801055fd:	c3                   	ret    

801055fe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801055fe:	55                   	push   %ebp
801055ff:	89 e5                	mov    %esp,%ebp
80105601:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105604:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010560b:	eb 30                	jmp    8010563d <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010560d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105613:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105616:	83 c2 08             	add    $0x8,%edx
80105619:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010561d:	85 c0                	test   %eax,%eax
8010561f:	75 18                	jne    80105639 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105621:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105627:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010562a:	8d 4a 08             	lea    0x8(%edx),%ecx
8010562d:	8b 55 08             	mov    0x8(%ebp),%edx
80105630:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105634:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105637:	eb 0f                	jmp    80105648 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105639:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010563d:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105641:	7e ca                	jle    8010560d <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105648:	c9                   	leave  
80105649:	c3                   	ret    

8010564a <sys_dup>:

int
sys_dup(void)
{
8010564a:	55                   	push   %ebp
8010564b:	89 e5                	mov    %esp,%ebp
8010564d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105650:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105653:	89 44 24 08          	mov    %eax,0x8(%esp)
80105657:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010565e:	00 
8010565f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105666:	e8 1e ff ff ff       	call   80105589 <argfd>
8010566b:	85 c0                	test   %eax,%eax
8010566d:	79 07                	jns    80105676 <sys_dup+0x2c>
    return -1;
8010566f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105674:	eb 29                	jmp    8010569f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105676:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105679:	89 04 24             	mov    %eax,(%esp)
8010567c:	e8 7d ff ff ff       	call   801055fe <fdalloc>
80105681:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105688:	79 07                	jns    80105691 <sys_dup+0x47>
    return -1;
8010568a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568f:	eb 0e                	jmp    8010569f <sys_dup+0x55>
  filedup(f);
80105691:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105694:	89 04 24             	mov    %eax,(%esp)
80105697:	e8 ea b8 ff ff       	call   80100f86 <filedup>
  return fd;
8010569c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010569f:	c9                   	leave  
801056a0:	c3                   	ret    

801056a1 <sys_read>:

int
sys_read(void)
{
801056a1:	55                   	push   %ebp
801056a2:	89 e5                	mov    %esp,%ebp
801056a4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801056ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056b5:	00 
801056b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056bd:	e8 c7 fe ff ff       	call   80105589 <argfd>
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 35                	js     801056fb <sys_read+0x5a>
801056c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056cd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056d4:	e8 5a fd ff ff       	call   80105433 <argint>
801056d9:	85 c0                	test   %eax,%eax
801056db:	78 1e                	js     801056fb <sys_read+0x5a>
801056dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e0:	89 44 24 08          	mov    %eax,0x8(%esp)
801056e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801056eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056f2:	e8 6a fd ff ff       	call   80105461 <argptr>
801056f7:	85 c0                	test   %eax,%eax
801056f9:	79 07                	jns    80105702 <sys_read+0x61>
    return -1;
801056fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105700:	eb 19                	jmp    8010571b <sys_read+0x7a>
  return fileread(f, p, n);
80105702:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105705:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010570f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105713:	89 04 24             	mov    %eax,(%esp)
80105716:	e8 d8 b9 ff ff       	call   801010f3 <fileread>
}
8010571b:	c9                   	leave  
8010571c:	c3                   	ret    

8010571d <sys_write>:

int
sys_write(void)
{
8010571d:	55                   	push   %ebp
8010571e:	89 e5                	mov    %esp,%ebp
80105720:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;
  
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105723:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105726:	89 44 24 08          	mov    %eax,0x8(%esp)
8010572a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105731:	00 
80105732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105739:	e8 4b fe ff ff       	call   80105589 <argfd>
8010573e:	85 c0                	test   %eax,%eax
80105740:	78 35                	js     80105777 <sys_write+0x5a>
80105742:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105745:	89 44 24 04          	mov    %eax,0x4(%esp)
80105749:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105750:	e8 de fc ff ff       	call   80105433 <argint>
80105755:	85 c0                	test   %eax,%eax
80105757:	78 1e                	js     80105777 <sys_write+0x5a>
80105759:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105760:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105763:	89 44 24 04          	mov    %eax,0x4(%esp)
80105767:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010576e:	e8 ee fc ff ff       	call   80105461 <argptr>
80105773:	85 c0                	test   %eax,%eax
80105775:	79 07                	jns    8010577e <sys_write+0x61>
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb 19                	jmp    80105797 <sys_write+0x7a>
  return filewrite(f, p, n);
8010577e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105781:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105787:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010578b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010578f:	89 04 24             	mov    %eax,(%esp)
80105792:	e8 18 ba ff ff       	call   801011af <filewrite>
}
80105797:	c9                   	leave  
80105798:	c3                   	ret    

80105799 <sys_close>:

int
sys_close(void)
{
80105799:	55                   	push   %ebp
8010579a:	89 e5                	mov    %esp,%ebp
8010579c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010579f:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a2:	89 44 24 08          	mov    %eax,0x8(%esp)
801057a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057b4:	e8 d0 fd ff ff       	call   80105589 <argfd>
801057b9:	85 c0                	test   %eax,%eax
801057bb:	79 07                	jns    801057c4 <sys_close+0x2b>
    return -1;
801057bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c2:	eb 24                	jmp    801057e8 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801057c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057cd:	83 c2 08             	add    $0x8,%edx
801057d0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801057d7:	00 
  fileclose(f);
801057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057db:	89 04 24             	mov    %eax,(%esp)
801057de:	e8 eb b7 ff ff       	call   80100fce <fileclose>
  return 0;
801057e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057e8:	c9                   	leave  
801057e9:	c3                   	ret    

801057ea <sys_fstat>:

int
sys_fstat(void)
{
801057ea:	55                   	push   %ebp
801057eb:	89 e5                	mov    %esp,%ebp
801057ed:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057fe:	00 
801057ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105806:	e8 7e fd ff ff       	call   80105589 <argfd>
8010580b:	85 c0                	test   %eax,%eax
8010580d:	78 1f                	js     8010582e <sys_fstat+0x44>
8010580f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105816:	00 
80105817:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010581a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105825:	e8 37 fc ff ff       	call   80105461 <argptr>
8010582a:	85 c0                	test   %eax,%eax
8010582c:	79 07                	jns    80105835 <sys_fstat+0x4b>
    return -1;
8010582e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105833:	eb 12                	jmp    80105847 <sys_fstat+0x5d>
  return filestat(f, st);
80105835:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010583f:	89 04 24             	mov    %eax,(%esp)
80105842:	e8 5d b8 ff ff       	call   801010a4 <filestat>
}
80105847:	c9                   	leave  
80105848:	c3                   	ret    

80105849 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105849:	55                   	push   %ebp
8010584a:	89 e5                	mov    %esp,%ebp
8010584c:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010584f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105852:	89 44 24 04          	mov    %eax,0x4(%esp)
80105856:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010585d:	e8 61 fc ff ff       	call   801054c3 <argstr>
80105862:	85 c0                	test   %eax,%eax
80105864:	78 17                	js     8010587d <sys_link+0x34>
80105866:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105869:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105874:	e8 4a fc ff ff       	call   801054c3 <argstr>
80105879:	85 c0                	test   %eax,%eax
8010587b:	79 0a                	jns    80105887 <sys_link+0x3e>
    return -1;
8010587d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105882:	e9 42 01 00 00       	jmp    801059c9 <sys_link+0x180>

  begin_op();
80105887:	e8 15 dc ff ff       	call   801034a1 <begin_op>
  if((ip = namei(old)) == 0){
8010588c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010588f:	89 04 24             	mov    %eax,(%esp)
80105892:	e8 d3 cb ff ff       	call   8010246a <namei>
80105897:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010589a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010589e:	75 0f                	jne    801058af <sys_link+0x66>
    end_op();
801058a0:	e8 80 dc ff ff       	call   80103525 <end_op>
    return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058aa:	e9 1a 01 00 00       	jmp    801059c9 <sys_link+0x180>
  }

  ilock(ip);
801058af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b2:	89 04 24             	mov    %eax,(%esp)
801058b5:	e8 ff bf ff ff       	call   801018b9 <ilock>
  if(ip->type == T_DIR){
801058ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058bd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058c1:	66 83 f8 01          	cmp    $0x1,%ax
801058c5:	75 1a                	jne    801058e1 <sys_link+0x98>
    iunlockput(ip);
801058c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ca:	89 04 24             	mov    %eax,(%esp)
801058cd:	e8 71 c2 ff ff       	call   80101b43 <iunlockput>
    end_op();
801058d2:	e8 4e dc ff ff       	call   80103525 <end_op>
    return -1;
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	e9 e8 00 00 00       	jmp    801059c9 <sys_link+0x180>
  }

  ip->nlink++;
801058e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801058e8:	8d 50 01             	lea    0x1(%eax),%edx
801058eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ee:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801058f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f5:	89 04 24             	mov    %eax,(%esp)
801058f8:	e8 fa bd ff ff       	call   801016f7 <iupdate>
  iunlock(ip);
801058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105900:	89 04 24             	mov    %eax,(%esp)
80105903:	e8 05 c1 ff ff       	call   80101a0d <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105908:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010590b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010590e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105912:	89 04 24             	mov    %eax,(%esp)
80105915:	e8 72 cb ff ff       	call   8010248c <nameiparent>
8010591a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010591d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105921:	75 02                	jne    80105925 <sys_link+0xdc>
    goto bad;
80105923:	eb 68                	jmp    8010598d <sys_link+0x144>
  ilock(dp);
80105925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105928:	89 04 24             	mov    %eax,(%esp)
8010592b:	e8 89 bf ff ff       	call   801018b9 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105933:	8b 10                	mov    (%eax),%edx
80105935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105938:	8b 00                	mov    (%eax),%eax
8010593a:	39 c2                	cmp    %eax,%edx
8010593c:	75 20                	jne    8010595e <sys_link+0x115>
8010593e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105941:	8b 40 04             	mov    0x4(%eax),%eax
80105944:	89 44 24 08          	mov    %eax,0x8(%esp)
80105948:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010594b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010594f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105952:	89 04 24             	mov    %eax,(%esp)
80105955:	e8 50 c8 ff ff       	call   801021aa <dirlink>
8010595a:	85 c0                	test   %eax,%eax
8010595c:	79 0d                	jns    8010596b <sys_link+0x122>
    iunlockput(dp);
8010595e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105961:	89 04 24             	mov    %eax,(%esp)
80105964:	e8 da c1 ff ff       	call   80101b43 <iunlockput>
    goto bad;
80105969:	eb 22                	jmp    8010598d <sys_link+0x144>
  }
  iunlockput(dp);
8010596b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010596e:	89 04 24             	mov    %eax,(%esp)
80105971:	e8 cd c1 ff ff       	call   80101b43 <iunlockput>
  iput(ip);
80105976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105979:	89 04 24             	mov    %eax,(%esp)
8010597c:	e8 f1 c0 ff ff       	call   80101a72 <iput>

  end_op();
80105981:	e8 9f db ff ff       	call   80103525 <end_op>

  return 0;
80105986:	b8 00 00 00 00       	mov    $0x0,%eax
8010598b:	eb 3c                	jmp    801059c9 <sys_link+0x180>

bad:
  ilock(ip);
8010598d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105990:	89 04 24             	mov    %eax,(%esp)
80105993:	e8 21 bf ff ff       	call   801018b9 <ilock>
  ip->nlink--;
80105998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010599f:	8d 50 ff             	lea    -0x1(%eax),%edx
801059a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ac:	89 04 24             	mov    %eax,(%esp)
801059af:	e8 43 bd ff ff       	call   801016f7 <iupdate>
  iunlockput(ip);
801059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b7:	89 04 24             	mov    %eax,(%esp)
801059ba:	e8 84 c1 ff ff       	call   80101b43 <iunlockput>
  end_op();
801059bf:	e8 61 db ff ff       	call   80103525 <end_op>
  return -1;
801059c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c9:	c9                   	leave  
801059ca:	c3                   	ret    

801059cb <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801059cb:	55                   	push   %ebp
801059cc:	89 e5                	mov    %esp,%ebp
801059ce:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059d1:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801059d8:	eb 4b                	jmp    80105a25 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059dd:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801059e4:	00 
801059e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801059e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f0:	8b 45 08             	mov    0x8(%ebp),%eax
801059f3:	89 04 24             	mov    %eax,(%esp)
801059f6:	e8 d1 c3 ff ff       	call   80101dcc <readi>
801059fb:	83 f8 10             	cmp    $0x10,%eax
801059fe:	74 0c                	je     80105a0c <isdirempty+0x41>
      panic("isdirempty: readi");
80105a00:	c7 04 24 ef 88 10 80 	movl   $0x801088ef,(%esp)
80105a07:	e8 2e ab ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105a0c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105a10:	66 85 c0             	test   %ax,%ax
80105a13:	74 07                	je     80105a1c <isdirempty+0x51>
      return 0;
80105a15:	b8 00 00 00 00       	mov    $0x0,%eax
80105a1a:	eb 1b                	jmp    80105a37 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1f:	83 c0 10             	add    $0x10,%eax
80105a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a28:	8b 45 08             	mov    0x8(%ebp),%eax
80105a2b:	8b 40 18             	mov    0x18(%eax),%eax
80105a2e:	39 c2                	cmp    %eax,%edx
80105a30:	72 a8                	jb     801059da <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105a32:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a37:	c9                   	leave  
80105a38:	c3                   	ret    

80105a39 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a39:	55                   	push   %ebp
80105a3a:	89 e5                	mov    %esp,%ebp
80105a3c:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a3f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a4d:	e8 71 fa ff ff       	call   801054c3 <argstr>
80105a52:	85 c0                	test   %eax,%eax
80105a54:	79 0a                	jns    80105a60 <sys_unlink+0x27>
    return -1;
80105a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5b:	e9 af 01 00 00       	jmp    80105c0f <sys_unlink+0x1d6>
  
  

  begin_op();
80105a60:	e8 3c da ff ff       	call   801034a1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a68:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105a6b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a6f:	89 04 24             	mov    %eax,(%esp)
80105a72:	e8 15 ca ff ff       	call   8010248c <nameiparent>
80105a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a7e:	75 0f                	jne    80105a8f <sys_unlink+0x56>
    end_op();
80105a80:	e8 a0 da ff ff       	call   80103525 <end_op>
    return -1;
80105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8a:	e9 80 01 00 00       	jmp    80105c0f <sys_unlink+0x1d6>
  }

  ilock(dp);
80105a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a92:	89 04 24             	mov    %eax,(%esp)
80105a95:	e8 1f be ff ff       	call   801018b9 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a9a:	c7 44 24 04 01 89 10 	movl   $0x80108901,0x4(%esp)
80105aa1:	80 
80105aa2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105aa5:	89 04 24             	mov    %eax,(%esp)
80105aa8:	e8 12 c6 ff ff       	call   801020bf <namecmp>
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	0f 84 45 01 00 00    	je     80105bfa <sys_unlink+0x1c1>
80105ab5:	c7 44 24 04 03 89 10 	movl   $0x80108903,0x4(%esp)
80105abc:	80 
80105abd:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ac0:	89 04 24             	mov    %eax,(%esp)
80105ac3:	e8 f7 c5 ff ff       	call   801020bf <namecmp>
80105ac8:	85 c0                	test   %eax,%eax
80105aca:	0f 84 2a 01 00 00    	je     80105bfa <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ad0:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ad7:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ada:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae1:	89 04 24             	mov    %eax,(%esp)
80105ae4:	e8 f8 c5 ff ff       	call   801020e1 <dirlookup>
80105ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105af0:	75 05                	jne    80105af7 <sys_unlink+0xbe>
    goto bad;
80105af2:	e9 03 01 00 00       	jmp    80105bfa <sys_unlink+0x1c1>
  ilock(ip);
80105af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afa:	89 04 24             	mov    %eax,(%esp)
80105afd:	e8 b7 bd ff ff       	call   801018b9 <ilock>

  if(ip->nlink < 1)
80105b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b05:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b09:	66 85 c0             	test   %ax,%ax
80105b0c:	7f 0c                	jg     80105b1a <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105b0e:	c7 04 24 06 89 10 80 	movl   $0x80108906,(%esp)
80105b15:	e8 20 aa ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b21:	66 83 f8 01          	cmp    $0x1,%ax
80105b25:	75 1f                	jne    80105b46 <sys_unlink+0x10d>
80105b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2a:	89 04 24             	mov    %eax,(%esp)
80105b2d:	e8 99 fe ff ff       	call   801059cb <isdirempty>
80105b32:	85 c0                	test   %eax,%eax
80105b34:	75 10                	jne    80105b46 <sys_unlink+0x10d>
    iunlockput(ip);
80105b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b39:	89 04 24             	mov    %eax,(%esp)
80105b3c:	e8 02 c0 ff ff       	call   80101b43 <iunlockput>
    goto bad;
80105b41:	e9 b4 00 00 00       	jmp    80105bfa <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105b46:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105b4d:	00 
80105b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b55:	00 
80105b56:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b59:	89 04 24             	mov    %eax,(%esp)
80105b5c:	e8 90 f5 ff ff       	call   801050f1 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b61:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105b64:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b6b:	00 
80105b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b70:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b73:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7a:	89 04 24             	mov    %eax,(%esp)
80105b7d:	e8 ae c3 ff ff       	call   80101f30 <writei>
80105b82:	83 f8 10             	cmp    $0x10,%eax
80105b85:	74 0c                	je     80105b93 <sys_unlink+0x15a>
    panic("unlink: writei");
80105b87:	c7 04 24 18 89 10 80 	movl   $0x80108918,(%esp)
80105b8e:	e8 a7 a9 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b96:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b9a:	66 83 f8 01          	cmp    $0x1,%ax
80105b9e:	75 1c                	jne    80105bbc <sys_unlink+0x183>
    dp->nlink--;
80105ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ba7:	8d 50 ff             	lea    -0x1(%eax),%edx
80105baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bad:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb4:	89 04 24             	mov    %eax,(%esp)
80105bb7:	e8 3b bb ff ff       	call   801016f7 <iupdate>
  }
  iunlockput(dp);
80105bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbf:	89 04 24             	mov    %eax,(%esp)
80105bc2:	e8 7c bf ff ff       	call   80101b43 <iunlockput>

  ip->nlink--;
80105bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bca:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bce:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd4:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bdb:	89 04 24             	mov    %eax,(%esp)
80105bde:	e8 14 bb ff ff       	call   801016f7 <iupdate>
  iunlockput(ip);
80105be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be6:	89 04 24             	mov    %eax,(%esp)
80105be9:	e8 55 bf ff ff       	call   80101b43 <iunlockput>

  end_op();
80105bee:	e8 32 d9 ff ff       	call   80103525 <end_op>

  return 0;
80105bf3:	b8 00 00 00 00       	mov    $0x0,%eax
80105bf8:	eb 15                	jmp    80105c0f <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfd:	89 04 24             	mov    %eax,(%esp)
80105c00:	e8 3e bf ff ff       	call   80101b43 <iunlockput>
  end_op();
80105c05:	e8 1b d9 ff ff       	call   80103525 <end_op>
  return -1;
80105c0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c0f:	c9                   	leave  
80105c10:	c3                   	ret    

80105c11 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c11:	55                   	push   %ebp
80105c12:	89 e5                	mov    %esp,%ebp
80105c14:	83 ec 48             	sub    $0x48,%esp
80105c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c1a:	8b 55 10             	mov    0x10(%ebp),%edx
80105c1d:	8b 45 14             	mov    0x14(%ebp),%eax
80105c20:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c24:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105c28:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c2c:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c33:	8b 45 08             	mov    0x8(%ebp),%eax
80105c36:	89 04 24             	mov    %eax,(%esp)
80105c39:	e8 4e c8 ff ff       	call   8010248c <nameiparent>
80105c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c45:	75 0a                	jne    80105c51 <create+0x40>
    return 0;
80105c47:	b8 00 00 00 00       	mov    $0x0,%eax
80105c4c:	e9 7e 01 00 00       	jmp    80105dcf <create+0x1be>
  ilock(dp);
80105c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c54:	89 04 24             	mov    %eax,(%esp)
80105c57:	e8 5d bc ff ff       	call   801018b9 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c63:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6d:	89 04 24             	mov    %eax,(%esp)
80105c70:	e8 6c c4 ff ff       	call   801020e1 <dirlookup>
80105c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c7c:	74 47                	je     80105cc5 <create+0xb4>
    iunlockput(dp);
80105c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c81:	89 04 24             	mov    %eax,(%esp)
80105c84:	e8 ba be ff ff       	call   80101b43 <iunlockput>
    ilock(ip);
80105c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8c:	89 04 24             	mov    %eax,(%esp)
80105c8f:	e8 25 bc ff ff       	call   801018b9 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c94:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c99:	75 15                	jne    80105cb0 <create+0x9f>
80105c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ca2:	66 83 f8 02          	cmp    $0x2,%ax
80105ca6:	75 08                	jne    80105cb0 <create+0x9f>
      return ip;
80105ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cab:	e9 1f 01 00 00       	jmp    80105dcf <create+0x1be>
    iunlockput(ip);
80105cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb3:	89 04 24             	mov    %eax,(%esp)
80105cb6:	e8 88 be ff ff       	call   80101b43 <iunlockput>
    return 0;
80105cbb:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc0:	e9 0a 01 00 00       	jmp    80105dcf <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105cc5:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccc:	8b 00                	mov    (%eax),%eax
80105cce:	89 54 24 04          	mov    %edx,0x4(%esp)
80105cd2:	89 04 24             	mov    %eax,(%esp)
80105cd5:	e8 48 b9 ff ff       	call   80101622 <ialloc>
80105cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ce1:	75 0c                	jne    80105cef <create+0xde>
    panic("create: ialloc");
80105ce3:	c7 04 24 27 89 10 80 	movl   $0x80108927,(%esp)
80105cea:	e8 4b a8 ff ff       	call   8010053a <panic>

  ilock(ip);
80105cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf2:	89 04 24             	mov    %eax,(%esp)
80105cf5:	e8 bf bb ff ff       	call   801018b9 <ilock>
  ip->major = major;
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105d01:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d08:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105d0c:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d13:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1c:	89 04 24             	mov    %eax,(%esp)
80105d1f:	e8 d3 b9 ff ff       	call   801016f7 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105d24:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d29:	75 6a                	jne    80105d95 <create+0x184>
    dp->nlink++;  // for ".."
80105d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d32:	8d 50 01             	lea    0x1(%eax),%edx
80105d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d38:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3f:	89 04 24             	mov    %eax,(%esp)
80105d42:	e8 b0 b9 ff ff       	call   801016f7 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4a:	8b 40 04             	mov    0x4(%eax),%eax
80105d4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d51:	c7 44 24 04 01 89 10 	movl   $0x80108901,0x4(%esp)
80105d58:	80 
80105d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5c:	89 04 24             	mov    %eax,(%esp)
80105d5f:	e8 46 c4 ff ff       	call   801021aa <dirlink>
80105d64:	85 c0                	test   %eax,%eax
80105d66:	78 21                	js     80105d89 <create+0x178>
80105d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6b:	8b 40 04             	mov    0x4(%eax),%eax
80105d6e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d72:	c7 44 24 04 03 89 10 	movl   $0x80108903,0x4(%esp)
80105d79:	80 
80105d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7d:	89 04 24             	mov    %eax,(%esp)
80105d80:	e8 25 c4 ff ff       	call   801021aa <dirlink>
80105d85:	85 c0                	test   %eax,%eax
80105d87:	79 0c                	jns    80105d95 <create+0x184>
      panic("create dots");
80105d89:	c7 04 24 36 89 10 80 	movl   $0x80108936,(%esp)
80105d90:	e8 a5 a7 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d98:	8b 40 04             	mov    0x4(%eax),%eax
80105d9b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d9f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105da2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da9:	89 04 24             	mov    %eax,(%esp)
80105dac:	e8 f9 c3 ff ff       	call   801021aa <dirlink>
80105db1:	85 c0                	test   %eax,%eax
80105db3:	79 0c                	jns    80105dc1 <create+0x1b0>
    panic("create: dirlink");
80105db5:	c7 04 24 42 89 10 80 	movl   $0x80108942,(%esp)
80105dbc:	e8 79 a7 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc4:	89 04 24             	mov    %eax,(%esp)
80105dc7:	e8 77 bd ff ff       	call   80101b43 <iunlockput>

  return ip;
80105dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105dcf:	c9                   	leave  
80105dd0:	c3                   	ret    

80105dd1 <sys_open>:

int
sys_open(void)
{
80105dd1:	55                   	push   %ebp
80105dd2:	89 e5                	mov    %esp,%ebp
80105dd4:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dd7:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105dda:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105de5:	e8 d9 f6 ff ff       	call   801054c3 <argstr>
80105dea:	85 c0                	test   %eax,%eax
80105dec:	78 17                	js     80105e05 <sys_open+0x34>
80105dee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105df5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dfc:	e8 32 f6 ff ff       	call   80105433 <argint>
80105e01:	85 c0                	test   %eax,%eax
80105e03:	79 0a                	jns    80105e0f <sys_open+0x3e>
    return -1;
80105e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0a:	e9 5c 01 00 00       	jmp    80105f6b <sys_open+0x19a>

  begin_op();
80105e0f:	e8 8d d6 ff ff       	call   801034a1 <begin_op>

  if(omode & O_CREATE){
80105e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e17:	25 00 02 00 00       	and    $0x200,%eax
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	74 3b                	je     80105e5b <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105e2a:	00 
80105e2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105e32:	00 
80105e33:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105e3a:	00 
80105e3b:	89 04 24             	mov    %eax,(%esp)
80105e3e:	e8 ce fd ff ff       	call   80105c11 <create>
80105e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105e46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e4a:	75 6b                	jne    80105eb7 <sys_open+0xe6>
      end_op();
80105e4c:	e8 d4 d6 ff ff       	call   80103525 <end_op>
      return -1;
80105e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e56:	e9 10 01 00 00       	jmp    80105f6b <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80105e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e5e:	89 04 24             	mov    %eax,(%esp)
80105e61:	e8 04 c6 ff ff       	call   8010246a <namei>
80105e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e6d:	75 0f                	jne    80105e7e <sys_open+0xad>
      end_op();
80105e6f:	e8 b1 d6 ff ff       	call   80103525 <end_op>
      return -1;
80105e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e79:	e9 ed 00 00 00       	jmp    80105f6b <sys_open+0x19a>
    }
    ilock(ip);
80105e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e81:	89 04 24             	mov    %eax,(%esp)
80105e84:	e8 30 ba ff ff       	call   801018b9 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e90:	66 83 f8 01          	cmp    $0x1,%ax
80105e94:	75 21                	jne    80105eb7 <sys_open+0xe6>
80105e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	74 1a                	je     80105eb7 <sys_open+0xe6>
      iunlockput(ip);
80105e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea0:	89 04 24             	mov    %eax,(%esp)
80105ea3:	e8 9b bc ff ff       	call   80101b43 <iunlockput>
      end_op();
80105ea8:	e8 78 d6 ff ff       	call   80103525 <end_op>
      return -1;
80105ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb2:	e9 b4 00 00 00       	jmp    80105f6b <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105eb7:	e8 6a b0 ff ff       	call   80100f26 <filealloc>
80105ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ec3:	74 14                	je     80105ed9 <sys_open+0x108>
80105ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec8:	89 04 24             	mov    %eax,(%esp)
80105ecb:	e8 2e f7 ff ff       	call   801055fe <fdalloc>
80105ed0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105ed3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105ed7:	79 28                	jns    80105f01 <sys_open+0x130>
    if(f)
80105ed9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105edd:	74 0b                	je     80105eea <sys_open+0x119>
      fileclose(f);
80105edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee2:	89 04 24             	mov    %eax,(%esp)
80105ee5:	e8 e4 b0 ff ff       	call   80100fce <fileclose>
    iunlockput(ip);
80105eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eed:	89 04 24             	mov    %eax,(%esp)
80105ef0:	e8 4e bc ff ff       	call   80101b43 <iunlockput>
    end_op();
80105ef5:	e8 2b d6 ff ff       	call   80103525 <end_op>
    return -1;
80105efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eff:	eb 6a                	jmp    80105f6b <sys_open+0x19a>
  }
  iunlock(ip);
80105f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f04:	89 04 24             	mov    %eax,(%esp)
80105f07:	e8 01 bb ff ff       	call   80101a0d <iunlock>
  end_op();
80105f0c:	e8 14 d6 ff ff       	call   80103525 <end_op>

  f->type = FD_INODE;
80105f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f14:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f20:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f26:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f30:	83 e0 01             	and    $0x1,%eax
80105f33:	85 c0                	test   %eax,%eax
80105f35:	0f 94 c0             	sete   %al
80105f38:	89 c2                	mov    %eax,%edx
80105f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f43:	83 e0 01             	and    $0x1,%eax
80105f46:	85 c0                	test   %eax,%eax
80105f48:	75 0a                	jne    80105f54 <sys_open+0x183>
80105f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f4d:	83 e0 02             	and    $0x2,%eax
80105f50:	85 c0                	test   %eax,%eax
80105f52:	74 07                	je     80105f5b <sys_open+0x18a>
80105f54:	b8 01 00 00 00       	mov    $0x1,%eax
80105f59:	eb 05                	jmp    80105f60 <sys_open+0x18f>
80105f5b:	b8 00 00 00 00       	mov    $0x0,%eax
80105f60:	89 c2                	mov    %eax,%edx
80105f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f65:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f6b:	c9                   	leave  
80105f6c:	c3                   	ret    

80105f6d <sys_mkdir>:

int
sys_mkdir(void)
{
80105f6d:	55                   	push   %ebp
80105f6e:	89 e5                	mov    %esp,%ebp
80105f70:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f73:	e8 29 d5 ff ff       	call   801034a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f78:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f86:	e8 38 f5 ff ff       	call   801054c3 <argstr>
80105f8b:	85 c0                	test   %eax,%eax
80105f8d:	78 2c                	js     80105fbb <sys_mkdir+0x4e>
80105f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f92:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f99:	00 
80105f9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105fa1:	00 
80105fa2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105fa9:	00 
80105faa:	89 04 24             	mov    %eax,(%esp)
80105fad:	e8 5f fc ff ff       	call   80105c11 <create>
80105fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fb9:	75 0c                	jne    80105fc7 <sys_mkdir+0x5a>
    end_op();
80105fbb:	e8 65 d5 ff ff       	call   80103525 <end_op>
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	eb 15                	jmp    80105fdc <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fca:	89 04 24             	mov    %eax,(%esp)
80105fcd:	e8 71 bb ff ff       	call   80101b43 <iunlockput>
  end_op();
80105fd2:	e8 4e d5 ff ff       	call   80103525 <end_op>
  return 0;
80105fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fdc:	c9                   	leave  
80105fdd:	c3                   	ret    

80105fde <sys_mknod>:

int
sys_mknod(void)
{
80105fde:	55                   	push   %ebp
80105fdf:	89 e5                	mov    %esp,%ebp
80105fe1:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80105fe4:	e8 b8 d4 ff ff       	call   801034a1 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80105fe9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ff7:	e8 c7 f4 ff ff       	call   801054c3 <argstr>
80105ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106003:	78 5e                	js     80106063 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106005:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106008:	89 44 24 04          	mov    %eax,0x4(%esp)
8010600c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106013:	e8 1b f4 ff ff       	call   80105433 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106018:	85 c0                	test   %eax,%eax
8010601a:	78 47                	js     80106063 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010601c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010601f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106023:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010602a:	e8 04 f4 ff ff       	call   80105433 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010602f:	85 c0                	test   %eax,%eax
80106031:	78 30                	js     80106063 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106036:	0f bf c8             	movswl %ax,%ecx
80106039:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010603c:	0f bf d0             	movswl %ax,%edx
8010603f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106042:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106046:	89 54 24 08          	mov    %edx,0x8(%esp)
8010604a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106051:	00 
80106052:	89 04 24             	mov    %eax,(%esp)
80106055:	e8 b7 fb ff ff       	call   80105c11 <create>
8010605a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010605d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106061:	75 0c                	jne    8010606f <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106063:	e8 bd d4 ff ff       	call   80103525 <end_op>
    return -1;
80106068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606d:	eb 15                	jmp    80106084 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010606f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106072:	89 04 24             	mov    %eax,(%esp)
80106075:	e8 c9 ba ff ff       	call   80101b43 <iunlockput>
  end_op();
8010607a:	e8 a6 d4 ff ff       	call   80103525 <end_op>
  return 0;
8010607f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106084:	c9                   	leave  
80106085:	c3                   	ret    

80106086 <sys_chdir>:

int
sys_chdir(void)
{
80106086:	55                   	push   %ebp
80106087:	89 e5                	mov    %esp,%ebp
80106089:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010608c:	e8 10 d4 ff ff       	call   801034a1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106091:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106094:	89 44 24 04          	mov    %eax,0x4(%esp)
80106098:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010609f:	e8 1f f4 ff ff       	call   801054c3 <argstr>
801060a4:	85 c0                	test   %eax,%eax
801060a6:	78 14                	js     801060bc <sys_chdir+0x36>
801060a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ab:	89 04 24             	mov    %eax,(%esp)
801060ae:	e8 b7 c3 ff ff       	call   8010246a <namei>
801060b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ba:	75 0c                	jne    801060c8 <sys_chdir+0x42>
    end_op();
801060bc:	e8 64 d4 ff ff       	call   80103525 <end_op>
    return -1;
801060c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c6:	eb 61                	jmp    80106129 <sys_chdir+0xa3>
  }
  ilock(ip);
801060c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060cb:	89 04 24             	mov    %eax,(%esp)
801060ce:	e8 e6 b7 ff ff       	call   801018b9 <ilock>
  if(ip->type != T_DIR){
801060d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060da:	66 83 f8 01          	cmp    $0x1,%ax
801060de:	74 17                	je     801060f7 <sys_chdir+0x71>
    iunlockput(ip);
801060e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e3:	89 04 24             	mov    %eax,(%esp)
801060e6:	e8 58 ba ff ff       	call   80101b43 <iunlockput>
    end_op();
801060eb:	e8 35 d4 ff ff       	call   80103525 <end_op>
    return -1;
801060f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f5:	eb 32                	jmp    80106129 <sys_chdir+0xa3>
  }
  iunlock(ip);
801060f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fa:	89 04 24             	mov    %eax,(%esp)
801060fd:	e8 0b b9 ff ff       	call   80101a0d <iunlock>
  iput(proc->cwd);
80106102:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106108:	8b 40 68             	mov    0x68(%eax),%eax
8010610b:	89 04 24             	mov    %eax,(%esp)
8010610e:	e8 5f b9 ff ff       	call   80101a72 <iput>
  end_op();
80106113:	e8 0d d4 ff ff       	call   80103525 <end_op>
  proc->cwd = ip;
80106118:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010611e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106121:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106124:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106129:	c9                   	leave  
8010612a:	c3                   	ret    

8010612b <sys_exec>:

int
sys_exec(void)
{
8010612b:	55                   	push   %ebp
8010612c:	89 e5                	mov    %esp,%ebp
8010612e:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106142:	e8 7c f3 ff ff       	call   801054c3 <argstr>
80106147:	85 c0                	test   %eax,%eax
80106149:	78 1a                	js     80106165 <sys_exec+0x3a>
8010614b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106151:	89 44 24 04          	mov    %eax,0x4(%esp)
80106155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010615c:	e8 d2 f2 ff ff       	call   80105433 <argint>
80106161:	85 c0                	test   %eax,%eax
80106163:	79 0a                	jns    8010616f <sys_exec+0x44>
    return -1;
80106165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616a:	e9 c8 00 00 00       	jmp    80106237 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
8010616f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106176:	00 
80106177:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010617e:	00 
8010617f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106185:	89 04 24             	mov    %eax,(%esp)
80106188:	e8 64 ef ff ff       	call   801050f1 <memset>
  for(i=0;; i++){
8010618d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106197:	83 f8 1f             	cmp    $0x1f,%eax
8010619a:	76 0a                	jbe    801061a6 <sys_exec+0x7b>
      return -1;
8010619c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a1:	e9 91 00 00 00       	jmp    80106237 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801061a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a9:	c1 e0 02             	shl    $0x2,%eax
801061ac:	89 c2                	mov    %eax,%edx
801061ae:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801061b4:	01 c2                	add    %eax,%edx
801061b6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c0:	89 14 24             	mov    %edx,(%esp)
801061c3:	e8 cf f1 ff ff       	call   80105397 <fetchint>
801061c8:	85 c0                	test   %eax,%eax
801061ca:	79 07                	jns    801061d3 <sys_exec+0xa8>
      return -1;
801061cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d1:	eb 64                	jmp    80106237 <sys_exec+0x10c>
    if(uarg == 0){
801061d3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061d9:	85 c0                	test   %eax,%eax
801061db:	75 26                	jne    80106203 <sys_exec+0xd8>
      argv[i] = 0;
801061dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e0:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801061e7:	00 00 00 00 
      break;
801061eb:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ef:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801061f9:	89 04 24             	mov    %eax,(%esp)
801061fc:	e8 ee a8 ff ff       	call   80100aef <exec>
80106201:	eb 34                	jmp    80106237 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106203:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106209:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010620c:	c1 e2 02             	shl    $0x2,%edx
8010620f:	01 c2                	add    %eax,%edx
80106211:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106217:	89 54 24 04          	mov    %edx,0x4(%esp)
8010621b:	89 04 24             	mov    %eax,(%esp)
8010621e:	e8 ae f1 ff ff       	call   801053d1 <fetchstr>
80106223:	85 c0                	test   %eax,%eax
80106225:	79 07                	jns    8010622e <sys_exec+0x103>
      return -1;
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb 09                	jmp    80106237 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010622e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106232:	e9 5d ff ff ff       	jmp    80106194 <sys_exec+0x69>
  return exec(path, argv);
}
80106237:	c9                   	leave  
80106238:	c3                   	ret    

80106239 <sys_pipe>:

int
sys_pipe(void)
{
80106239:	55                   	push   %ebp
8010623a:	89 e5                	mov    %esp,%ebp
8010623c:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010623f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106246:	00 
80106247:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010624a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010624e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106255:	e8 07 f2 ff ff       	call   80105461 <argptr>
8010625a:	85 c0                	test   %eax,%eax
8010625c:	79 0a                	jns    80106268 <sys_pipe+0x2f>
    return -1;
8010625e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106263:	e9 9b 00 00 00       	jmp    80106303 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106268:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010626b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010626f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106272:	89 04 24             	mov    %eax,(%esp)
80106275:	e8 33 dd ff ff       	call   80103fad <pipealloc>
8010627a:	85 c0                	test   %eax,%eax
8010627c:	79 07                	jns    80106285 <sys_pipe+0x4c>
    return -1;
8010627e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106283:	eb 7e                	jmp    80106303 <sys_pipe+0xca>
  fd0 = -1;
80106285:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010628c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010628f:	89 04 24             	mov    %eax,(%esp)
80106292:	e8 67 f3 ff ff       	call   801055fe <fdalloc>
80106297:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010629a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629e:	78 14                	js     801062b4 <sys_pipe+0x7b>
801062a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062a3:	89 04 24             	mov    %eax,(%esp)
801062a6:	e8 53 f3 ff ff       	call   801055fe <fdalloc>
801062ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062b2:	79 37                	jns    801062eb <sys_pipe+0xb2>
    if(fd0 >= 0)
801062b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b8:	78 14                	js     801062ce <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801062ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062c3:	83 c2 08             	add    $0x8,%edx
801062c6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801062cd:	00 
    fileclose(rf);
801062ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062d1:	89 04 24             	mov    %eax,(%esp)
801062d4:	e8 f5 ac ff ff       	call   80100fce <fileclose>
    fileclose(wf);
801062d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062dc:	89 04 24             	mov    %eax,(%esp)
801062df:	e8 ea ac ff ff       	call   80100fce <fileclose>
    return -1;
801062e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e9:	eb 18                	jmp    80106303 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801062eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062f1:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801062f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062f6:	8d 50 04             	lea    0x4(%eax),%edx
801062f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fc:	89 02                	mov    %eax,(%edx)
  return 0;
801062fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106303:	c9                   	leave  
80106304:	c3                   	ret    

80106305 <sys_fork>:



int
sys_fork(void)
{
80106305:	55                   	push   %ebp
80106306:	89 e5                	mov    %esp,%ebp
80106308:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010630b:	e8 48 e3 ff ff       	call   80104658 <fork>
}
80106310:	c9                   	leave  
80106311:	c3                   	ret    

80106312 <sys_exit>:

int
sys_exit(void)
{
80106312:	55                   	push   %ebp
80106313:	89 e5                	mov    %esp,%ebp
80106315:	83 ec 08             	sub    $0x8,%esp
  exit();
80106318:	e8 b6 e4 ff ff       	call   801047d3 <exit>
  return 0;  // not reached
8010631d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106322:	c9                   	leave  
80106323:	c3                   	ret    

80106324 <sys_wait>:

int
sys_wait(void)
{
80106324:	55                   	push   %ebp
80106325:	89 e5                	mov    %esp,%ebp
80106327:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010632a:	e8 c6 e5 ff ff       	call   801048f5 <wait>
}
8010632f:	c9                   	leave  
80106330:	c3                   	ret    

80106331 <sys_kill>:

int
sys_kill(void)
{
80106331:	55                   	push   %ebp
80106332:	89 e5                	mov    %esp,%ebp
80106334:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010633a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010633e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106345:	e8 e9 f0 ff ff       	call   80105433 <argint>
8010634a:	85 c0                	test   %eax,%eax
8010634c:	79 07                	jns    80106355 <sys_kill+0x24>
    return -1;
8010634e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106353:	eb 0b                	jmp    80106360 <sys_kill+0x2f>
  return kill(pid);
80106355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106358:	89 04 24             	mov    %eax,(%esp)
8010635b:	e8 63 e9 ff ff       	call   80104cc3 <kill>
}
80106360:	c9                   	leave  
80106361:	c3                   	ret    

80106362 <sys_getpid>:

int
sys_getpid(void)
{
80106362:	55                   	push   %ebp
80106363:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106365:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010636b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010636e:	5d                   	pop    %ebp
8010636f:	c3                   	ret    

80106370 <sys_sbrk>:

int
sys_sbrk(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106376:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010637d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106384:	e8 aa f0 ff ff       	call   80105433 <argint>
80106389:	85 c0                	test   %eax,%eax
8010638b:	79 07                	jns    80106394 <sys_sbrk+0x24>
    return -1;
8010638d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106392:	eb 24                	jmp    801063b8 <sys_sbrk+0x48>
  addr = proc->sz;
80106394:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010639a:	8b 00                	mov    (%eax),%eax
8010639c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010639f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a2:	89 04 24             	mov    %eax,(%esp)
801063a5:	e8 09 e2 ff ff       	call   801045b3 <growproc>
801063aa:	85 c0                	test   %eax,%eax
801063ac:	79 07                	jns    801063b5 <sys_sbrk+0x45>
    return -1;
801063ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b3:	eb 03                	jmp    801063b8 <sys_sbrk+0x48>
  return addr;
801063b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801063b8:	c9                   	leave  
801063b9:	c3                   	ret    

801063ba <sys_sleep>:

int
sys_sleep(void)
{
801063ba:	55                   	push   %ebp
801063bb:	89 e5                	mov    %esp,%ebp
801063bd:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801063c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063ce:	e8 60 f0 ff ff       	call   80105433 <argint>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	79 07                	jns    801063de <sys_sleep+0x24>
    return -1;
801063d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063dc:	eb 6c                	jmp    8010644a <sys_sleep+0x90>
  acquire(&tickslock);
801063de:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801063e5:	e8 a9 ea ff ff       	call   80104e93 <acquire>
  ticks0 = ticks;
801063ea:	a1 00 51 11 80       	mov    0x80115100,%eax
801063ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801063f2:	eb 34                	jmp    80106428 <sys_sleep+0x6e>
    if(proc->killed){
801063f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063fa:	8b 40 24             	mov    0x24(%eax),%eax
801063fd:	85 c0                	test   %eax,%eax
801063ff:	74 13                	je     80106414 <sys_sleep+0x5a>
      release(&tickslock);
80106401:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80106408:	e8 e8 ea ff ff       	call   80104ef5 <release>
      return -1;
8010640d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106412:	eb 36                	jmp    8010644a <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106414:	c7 44 24 04 c0 48 11 	movl   $0x801148c0,0x4(%esp)
8010641b:	80 
8010641c:	c7 04 24 00 51 11 80 	movl   $0x80115100,(%esp)
80106423:	e8 97 e7 ff ff       	call   80104bbf <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106428:	a1 00 51 11 80       	mov    0x80115100,%eax
8010642d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106430:	89 c2                	mov    %eax,%edx
80106432:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106435:	39 c2                	cmp    %eax,%edx
80106437:	72 bb                	jb     801063f4 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106439:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80106440:	e8 b0 ea ff ff       	call   80104ef5 <release>
  return 0;
80106445:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010644a:	c9                   	leave  
8010644b:	c3                   	ret    

8010644c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010644c:	55                   	push   %ebp
8010644d:	89 e5                	mov    %esp,%ebp
8010644f:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106452:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80106459:	e8 35 ea ff ff       	call   80104e93 <acquire>
  xticks = ticks;
8010645e:	a1 00 51 11 80       	mov    0x80115100,%eax
80106463:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106466:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
8010646d:	e8 83 ea ff ff       	call   80104ef5 <release>
  return xticks;
80106472:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106475:	c9                   	leave  
80106476:	c3                   	ret    

80106477 <sys_getuser>:


int
sys_getuser(void){
80106477:	55                   	push   %ebp
80106478:	89 e5                	mov    %esp,%ebp
	return CURRENT_USER;
8010647a:	a1 04 b0 10 80       	mov    0x8010b004,%eax
}
8010647f:	5d                   	pop    %ebp
80106480:	c3                   	ret    

80106481 <sys_setuser>:

int
sys_setuser(void){
80106481:	55                   	push   %ebp
80106482:	89 e5                	mov    %esp,%ebp
80106484:	83 ec 18             	sub    $0x18,%esp
	argint(0,&CURRENT_USER);
80106487:	c7 44 24 04 04 b0 10 	movl   $0x8010b004,0x4(%esp)
8010648e:	80 
8010648f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106496:	e8 98 ef ff ff       	call   80105433 <argint>
	return 1;
8010649b:	b8 01 00 00 00       	mov    $0x1,%eax
801064a0:	c9                   	leave  
801064a1:	c3                   	ret    

801064a2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801064a2:	55                   	push   %ebp
801064a3:	89 e5                	mov    %esp,%ebp
801064a5:	83 ec 08             	sub    $0x8,%esp
801064a8:	8b 55 08             	mov    0x8(%ebp),%edx
801064ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801064ae:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801064b2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064b5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801064b9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801064bd:	ee                   	out    %al,(%dx)
}
801064be:	c9                   	leave  
801064bf:	c3                   	ret    

801064c0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801064c6:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801064cd:	00 
801064ce:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801064d5:	e8 c8 ff ff ff       	call   801064a2 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801064da:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801064e1:	00 
801064e2:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801064e9:	e8 b4 ff ff ff       	call   801064a2 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801064ee:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801064f5:	00 
801064f6:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801064fd:	e8 a0 ff ff ff       	call   801064a2 <outb>
  picenable(IRQ_TIMER);
80106502:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106509:	e8 32 d9 ff ff       	call   80103e40 <picenable>
}
8010650e:	c9                   	leave  
8010650f:	c3                   	ret    

80106510 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106510:	1e                   	push   %ds
  pushl %es
80106511:	06                   	push   %es
  pushl %fs
80106512:	0f a0                	push   %fs
  pushl %gs
80106514:	0f a8                	push   %gs
  pushal
80106516:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106517:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010651b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010651d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010651f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106523:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106525:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106527:	54                   	push   %esp
  call trap
80106528:	e8 d8 01 00 00       	call   80106705 <trap>
  addl $4, %esp
8010652d:	83 c4 04             	add    $0x4,%esp

80106530 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106530:	61                   	popa   
  popl %gs
80106531:	0f a9                	pop    %gs
  popl %fs
80106533:	0f a1                	pop    %fs
  popl %es
80106535:	07                   	pop    %es
  popl %ds
80106536:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106537:	83 c4 08             	add    $0x8,%esp
  iret
8010653a:	cf                   	iret   

8010653b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010653b:	55                   	push   %ebp
8010653c:	89 e5                	mov    %esp,%ebp
8010653e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106541:	8b 45 0c             	mov    0xc(%ebp),%eax
80106544:	83 e8 01             	sub    $0x1,%eax
80106547:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010654b:	8b 45 08             	mov    0x8(%ebp),%eax
8010654e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106552:	8b 45 08             	mov    0x8(%ebp),%eax
80106555:	c1 e8 10             	shr    $0x10,%eax
80106558:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010655c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010655f:	0f 01 18             	lidtl  (%eax)
}
80106562:	c9                   	leave  
80106563:	c3                   	ret    

80106564 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010656a:	0f 20 d0             	mov    %cr2,%eax
8010656d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106570:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106573:	c9                   	leave  
80106574:	c3                   	ret    

80106575 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106575:	55                   	push   %ebp
80106576:	89 e5                	mov    %esp,%ebp
80106578:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010657b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106582:	e9 c3 00 00 00       	jmp    8010664a <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658a:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
80106591:	89 c2                	mov    %eax,%edx
80106593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106596:	66 89 14 c5 00 49 11 	mov    %dx,-0x7feeb700(,%eax,8)
8010659d:	80 
8010659e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a1:	66 c7 04 c5 02 49 11 	movw   $0x8,-0x7feeb6fe(,%eax,8)
801065a8:	80 08 00 
801065ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ae:	0f b6 14 c5 04 49 11 	movzbl -0x7feeb6fc(,%eax,8),%edx
801065b5:	80 
801065b6:	83 e2 e0             	and    $0xffffffe0,%edx
801065b9:	88 14 c5 04 49 11 80 	mov    %dl,-0x7feeb6fc(,%eax,8)
801065c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c3:	0f b6 14 c5 04 49 11 	movzbl -0x7feeb6fc(,%eax,8),%edx
801065ca:	80 
801065cb:	83 e2 1f             	and    $0x1f,%edx
801065ce:	88 14 c5 04 49 11 80 	mov    %dl,-0x7feeb6fc(,%eax,8)
801065d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d8:	0f b6 14 c5 05 49 11 	movzbl -0x7feeb6fb(,%eax,8),%edx
801065df:	80 
801065e0:	83 e2 f0             	and    $0xfffffff0,%edx
801065e3:	83 ca 0e             	or     $0xe,%edx
801065e6:	88 14 c5 05 49 11 80 	mov    %dl,-0x7feeb6fb(,%eax,8)
801065ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f0:	0f b6 14 c5 05 49 11 	movzbl -0x7feeb6fb(,%eax,8),%edx
801065f7:	80 
801065f8:	83 e2 ef             	and    $0xffffffef,%edx
801065fb:	88 14 c5 05 49 11 80 	mov    %dl,-0x7feeb6fb(,%eax,8)
80106602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106605:	0f b6 14 c5 05 49 11 	movzbl -0x7feeb6fb(,%eax,8),%edx
8010660c:	80 
8010660d:	83 e2 9f             	and    $0xffffff9f,%edx
80106610:	88 14 c5 05 49 11 80 	mov    %dl,-0x7feeb6fb(,%eax,8)
80106617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661a:	0f b6 14 c5 05 49 11 	movzbl -0x7feeb6fb(,%eax,8),%edx
80106621:	80 
80106622:	83 ca 80             	or     $0xffffff80,%edx
80106625:	88 14 c5 05 49 11 80 	mov    %dl,-0x7feeb6fb(,%eax,8)
8010662c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662f:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
80106636:	c1 e8 10             	shr    $0x10,%eax
80106639:	89 c2                	mov    %eax,%edx
8010663b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663e:	66 89 14 c5 06 49 11 	mov    %dx,-0x7feeb6fa(,%eax,8)
80106645:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106646:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010664a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106651:	0f 8e 30 ff ff ff    	jle    80106587 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106657:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
8010665c:	66 a3 00 4b 11 80    	mov    %ax,0x80114b00
80106662:	66 c7 05 02 4b 11 80 	movw   $0x8,0x80114b02
80106669:	08 00 
8010666b:	0f b6 05 04 4b 11 80 	movzbl 0x80114b04,%eax
80106672:	83 e0 e0             	and    $0xffffffe0,%eax
80106675:	a2 04 4b 11 80       	mov    %al,0x80114b04
8010667a:	0f b6 05 04 4b 11 80 	movzbl 0x80114b04,%eax
80106681:	83 e0 1f             	and    $0x1f,%eax
80106684:	a2 04 4b 11 80       	mov    %al,0x80114b04
80106689:	0f b6 05 05 4b 11 80 	movzbl 0x80114b05,%eax
80106690:	83 c8 0f             	or     $0xf,%eax
80106693:	a2 05 4b 11 80       	mov    %al,0x80114b05
80106698:	0f b6 05 05 4b 11 80 	movzbl 0x80114b05,%eax
8010669f:	83 e0 ef             	and    $0xffffffef,%eax
801066a2:	a2 05 4b 11 80       	mov    %al,0x80114b05
801066a7:	0f b6 05 05 4b 11 80 	movzbl 0x80114b05,%eax
801066ae:	83 c8 60             	or     $0x60,%eax
801066b1:	a2 05 4b 11 80       	mov    %al,0x80114b05
801066b6:	0f b6 05 05 4b 11 80 	movzbl 0x80114b05,%eax
801066bd:	83 c8 80             	or     $0xffffff80,%eax
801066c0:	a2 05 4b 11 80       	mov    %al,0x80114b05
801066c5:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
801066ca:	c1 e8 10             	shr    $0x10,%eax
801066cd:	66 a3 06 4b 11 80    	mov    %ax,0x80114b06
  
  initlock(&tickslock, "time");
801066d3:	c7 44 24 04 54 89 10 	movl   $0x80108954,0x4(%esp)
801066da:	80 
801066db:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801066e2:	e8 8b e7 ff ff       	call   80104e72 <initlock>
}
801066e7:	c9                   	leave  
801066e8:	c3                   	ret    

801066e9 <idtinit>:

void
idtinit(void)
{
801066e9:	55                   	push   %ebp
801066ea:	89 e5                	mov    %esp,%ebp
801066ec:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801066ef:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801066f6:	00 
801066f7:	c7 04 24 00 49 11 80 	movl   $0x80114900,(%esp)
801066fe:	e8 38 fe ff ff       	call   8010653b <lidt>
}
80106703:	c9                   	leave  
80106704:	c3                   	ret    

80106705 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106705:	55                   	push   %ebp
80106706:	89 e5                	mov    %esp,%ebp
80106708:	57                   	push   %edi
80106709:	56                   	push   %esi
8010670a:	53                   	push   %ebx
8010670b:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010670e:	8b 45 08             	mov    0x8(%ebp),%eax
80106711:	8b 40 30             	mov    0x30(%eax),%eax
80106714:	83 f8 40             	cmp    $0x40,%eax
80106717:	75 3f                	jne    80106758 <trap+0x53>
    if(proc->killed)
80106719:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010671f:	8b 40 24             	mov    0x24(%eax),%eax
80106722:	85 c0                	test   %eax,%eax
80106724:	74 05                	je     8010672b <trap+0x26>
      exit();
80106726:	e8 a8 e0 ff ff       	call   801047d3 <exit>
    proc->tf = tf;
8010672b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106731:	8b 55 08             	mov    0x8(%ebp),%edx
80106734:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106737:	e8 be ed ff ff       	call   801054fa <syscall>
    if(proc->killed)
8010673c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106742:	8b 40 24             	mov    0x24(%eax),%eax
80106745:	85 c0                	test   %eax,%eax
80106747:	74 0a                	je     80106753 <trap+0x4e>
      exit();
80106749:	e8 85 e0 ff ff       	call   801047d3 <exit>
    return;
8010674e:	e9 2d 02 00 00       	jmp    80106980 <trap+0x27b>
80106753:	e9 28 02 00 00       	jmp    80106980 <trap+0x27b>
  }

  switch(tf->trapno){
80106758:	8b 45 08             	mov    0x8(%ebp),%eax
8010675b:	8b 40 30             	mov    0x30(%eax),%eax
8010675e:	83 e8 20             	sub    $0x20,%eax
80106761:	83 f8 1f             	cmp    $0x1f,%eax
80106764:	0f 87 bc 00 00 00    	ja     80106826 <trap+0x121>
8010676a:	8b 04 85 fc 89 10 80 	mov    -0x7fef7604(,%eax,4),%eax
80106771:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106773:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106779:	0f b6 00             	movzbl (%eax),%eax
8010677c:	84 c0                	test   %al,%al
8010677e:	75 31                	jne    801067b1 <trap+0xac>
      acquire(&tickslock);
80106780:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
80106787:	e8 07 e7 ff ff       	call   80104e93 <acquire>
      ticks++;
8010678c:	a1 00 51 11 80       	mov    0x80115100,%eax
80106791:	83 c0 01             	add    $0x1,%eax
80106794:	a3 00 51 11 80       	mov    %eax,0x80115100
      wakeup(&ticks);
80106799:	c7 04 24 00 51 11 80 	movl   $0x80115100,(%esp)
801067a0:	e8 f3 e4 ff ff       	call   80104c98 <wakeup>
      release(&tickslock);
801067a5:	c7 04 24 c0 48 11 80 	movl   $0x801148c0,(%esp)
801067ac:	e8 44 e7 ff ff       	call   80104ef5 <release>
    }
    lapiceoi();
801067b1:	e8 b5 c7 ff ff       	call   80102f6b <lapiceoi>
    break;
801067b6:	e9 41 01 00 00       	jmp    801068fc <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801067bb:	e8 b9 bf ff ff       	call   80102779 <ideintr>
    lapiceoi();
801067c0:	e8 a6 c7 ff ff       	call   80102f6b <lapiceoi>
    break;
801067c5:	e9 32 01 00 00       	jmp    801068fc <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801067ca:	e8 6b c5 ff ff       	call   80102d3a <kbdintr>
    lapiceoi();
801067cf:	e8 97 c7 ff ff       	call   80102f6b <lapiceoi>
    break;
801067d4:	e9 23 01 00 00       	jmp    801068fc <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801067d9:	e8 97 03 00 00       	call   80106b75 <uartintr>
    lapiceoi();
801067de:	e8 88 c7 ff ff       	call   80102f6b <lapiceoi>
    break;
801067e3:	e9 14 01 00 00       	jmp    801068fc <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067e8:	8b 45 08             	mov    0x8(%ebp),%eax
801067eb:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801067ee:	8b 45 08             	mov    0x8(%ebp),%eax
801067f1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067f5:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801067f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067fe:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106801:	0f b6 c0             	movzbl %al,%eax
80106804:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106808:	89 54 24 08          	mov    %edx,0x8(%esp)
8010680c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106810:	c7 04 24 5c 89 10 80 	movl   $0x8010895c,(%esp)
80106817:	e8 84 9b ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010681c:	e8 4a c7 ff ff       	call   80102f6b <lapiceoi>
    break;
80106821:	e9 d6 00 00 00       	jmp    801068fc <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106826:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010682c:	85 c0                	test   %eax,%eax
8010682e:	74 11                	je     80106841 <trap+0x13c>
80106830:	8b 45 08             	mov    0x8(%ebp),%eax
80106833:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106837:	0f b7 c0             	movzwl %ax,%eax
8010683a:	83 e0 03             	and    $0x3,%eax
8010683d:	85 c0                	test   %eax,%eax
8010683f:	75 46                	jne    80106887 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106841:	e8 1e fd ff ff       	call   80106564 <rcr2>
80106846:	8b 55 08             	mov    0x8(%ebp),%edx
80106849:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010684c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106853:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106856:	0f b6 ca             	movzbl %dl,%ecx
80106859:	8b 55 08             	mov    0x8(%ebp),%edx
8010685c:	8b 52 30             	mov    0x30(%edx),%edx
8010685f:	89 44 24 10          	mov    %eax,0x10(%esp)
80106863:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106867:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010686b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010686f:	c7 04 24 80 89 10 80 	movl   $0x80108980,(%esp)
80106876:	e8 25 9b ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010687b:	c7 04 24 b2 89 10 80 	movl   $0x801089b2,(%esp)
80106882:	e8 b3 9c ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106887:	e8 d8 fc ff ff       	call   80106564 <rcr2>
8010688c:	89 c2                	mov    %eax,%edx
8010688e:	8b 45 08             	mov    0x8(%ebp),%eax
80106891:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106894:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010689a:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010689d:	0f b6 f0             	movzbl %al,%esi
801068a0:	8b 45 08             	mov    0x8(%ebp),%eax
801068a3:	8b 58 34             	mov    0x34(%eax),%ebx
801068a6:	8b 45 08             	mov    0x8(%ebp),%eax
801068a9:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801068ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068b2:	83 c0 6c             	add    $0x6c,%eax
801068b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068be:	8b 40 10             	mov    0x10(%eax),%eax
801068c1:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801068c5:	89 7c 24 18          	mov    %edi,0x18(%esp)
801068c9:	89 74 24 14          	mov    %esi,0x14(%esp)
801068cd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801068d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801068d5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801068d8:	89 74 24 08          	mov    %esi,0x8(%esp)
801068dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801068e0:	c7 04 24 b8 89 10 80 	movl   $0x801089b8,(%esp)
801068e7:	e8 b4 9a ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801068ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801068f9:	eb 01                	jmp    801068fc <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801068fb:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801068fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106902:	85 c0                	test   %eax,%eax
80106904:	74 24                	je     8010692a <trap+0x225>
80106906:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010690c:	8b 40 24             	mov    0x24(%eax),%eax
8010690f:	85 c0                	test   %eax,%eax
80106911:	74 17                	je     8010692a <trap+0x225>
80106913:	8b 45 08             	mov    0x8(%ebp),%eax
80106916:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010691a:	0f b7 c0             	movzwl %ax,%eax
8010691d:	83 e0 03             	and    $0x3,%eax
80106920:	83 f8 03             	cmp    $0x3,%eax
80106923:	75 05                	jne    8010692a <trap+0x225>
    exit();
80106925:	e8 a9 de ff ff       	call   801047d3 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010692a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106930:	85 c0                	test   %eax,%eax
80106932:	74 1e                	je     80106952 <trap+0x24d>
80106934:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010693a:	8b 40 0c             	mov    0xc(%eax),%eax
8010693d:	83 f8 04             	cmp    $0x4,%eax
80106940:	75 10                	jne    80106952 <trap+0x24d>
80106942:	8b 45 08             	mov    0x8(%ebp),%eax
80106945:	8b 40 30             	mov    0x30(%eax),%eax
80106948:	83 f8 20             	cmp    $0x20,%eax
8010694b:	75 05                	jne    80106952 <trap+0x24d>
    yield();
8010694d:	e8 fc e1 ff ff       	call   80104b4e <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106952:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 24                	je     80106980 <trap+0x27b>
8010695c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106962:	8b 40 24             	mov    0x24(%eax),%eax
80106965:	85 c0                	test   %eax,%eax
80106967:	74 17                	je     80106980 <trap+0x27b>
80106969:	8b 45 08             	mov    0x8(%ebp),%eax
8010696c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106970:	0f b7 c0             	movzwl %ax,%eax
80106973:	83 e0 03             	and    $0x3,%eax
80106976:	83 f8 03             	cmp    $0x3,%eax
80106979:	75 05                	jne    80106980 <trap+0x27b>
    exit();
8010697b:	e8 53 de ff ff       	call   801047d3 <exit>
}
80106980:	83 c4 3c             	add    $0x3c,%esp
80106983:	5b                   	pop    %ebx
80106984:	5e                   	pop    %esi
80106985:	5f                   	pop    %edi
80106986:	5d                   	pop    %ebp
80106987:	c3                   	ret    

80106988 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106988:	55                   	push   %ebp
80106989:	89 e5                	mov    %esp,%ebp
8010698b:	83 ec 14             	sub    $0x14,%esp
8010698e:	8b 45 08             	mov    0x8(%ebp),%eax
80106991:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106995:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106999:	89 c2                	mov    %eax,%edx
8010699b:	ec                   	in     (%dx),%al
8010699c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010699f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801069a3:	c9                   	leave  
801069a4:	c3                   	ret    

801069a5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801069a5:	55                   	push   %ebp
801069a6:	89 e5                	mov    %esp,%ebp
801069a8:	83 ec 08             	sub    $0x8,%esp
801069ab:	8b 55 08             	mov    0x8(%ebp),%edx
801069ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801069b1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801069b5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069b8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801069bc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801069c0:	ee                   	out    %al,(%dx)
}
801069c1:	c9                   	leave  
801069c2:	c3                   	ret    

801069c3 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801069c3:	55                   	push   %ebp
801069c4:	89 e5                	mov    %esp,%ebp
801069c6:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801069c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069d0:	00 
801069d1:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801069d8:	e8 c8 ff ff ff       	call   801069a5 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801069dd:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801069e4:	00 
801069e5:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801069ec:	e8 b4 ff ff ff       	call   801069a5 <outb>
  outb(COM1+0, 115200/9600);
801069f1:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801069f8:	00 
801069f9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a00:	e8 a0 ff ff ff       	call   801069a5 <outb>
  outb(COM1+1, 0);
80106a05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a0c:	00 
80106a0d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106a14:	e8 8c ff ff ff       	call   801069a5 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a19:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106a20:	00 
80106a21:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106a28:	e8 78 ff ff ff       	call   801069a5 <outb>
  outb(COM1+4, 0);
80106a2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a34:	00 
80106a35:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106a3c:	e8 64 ff ff ff       	call   801069a5 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106a48:	00 
80106a49:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106a50:	e8 50 ff ff ff       	call   801069a5 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a55:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106a5c:	e8 27 ff ff ff       	call   80106988 <inb>
80106a61:	3c ff                	cmp    $0xff,%al
80106a63:	75 02                	jne    80106a67 <uartinit+0xa4>
    return;
80106a65:	eb 6a                	jmp    80106ad1 <uartinit+0x10e>
  uart = 1;
80106a67:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106a6e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a71:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106a78:	e8 0b ff ff ff       	call   80106988 <inb>
  inb(COM1+0);
80106a7d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a84:	e8 ff fe ff ff       	call   80106988 <inb>
  picenable(IRQ_COM1);
80106a89:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106a90:	e8 ab d3 ff ff       	call   80103e40 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106a95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a9c:	00 
80106a9d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106aa4:	e8 4f bf ff ff       	call   801029f8 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106aa9:	c7 45 f4 7c 8a 10 80 	movl   $0x80108a7c,-0xc(%ebp)
80106ab0:	eb 15                	jmp    80106ac7 <uartinit+0x104>
    uartputc(*p);
80106ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab5:	0f b6 00             	movzbl (%eax),%eax
80106ab8:	0f be c0             	movsbl %al,%eax
80106abb:	89 04 24             	mov    %eax,(%esp)
80106abe:	e8 10 00 00 00       	call   80106ad3 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ac3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aca:	0f b6 00             	movzbl (%eax),%eax
80106acd:	84 c0                	test   %al,%al
80106acf:	75 e1                	jne    80106ab2 <uartinit+0xef>
    uartputc(*p);
}
80106ad1:	c9                   	leave  
80106ad2:	c3                   	ret    

80106ad3 <uartputc>:

void
uartputc(int c)
{
80106ad3:	55                   	push   %ebp
80106ad4:	89 e5                	mov    %esp,%ebp
80106ad6:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106ad9:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106ade:	85 c0                	test   %eax,%eax
80106ae0:	75 02                	jne    80106ae4 <uartputc+0x11>
    return;
80106ae2:	eb 4b                	jmp    80106b2f <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ae4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106aeb:	eb 10                	jmp    80106afd <uartputc+0x2a>
    microdelay(10);
80106aed:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106af4:	e8 97 c4 ff ff       	call   80102f90 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106af9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106afd:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b01:	7f 16                	jg     80106b19 <uartputc+0x46>
80106b03:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b0a:	e8 79 fe ff ff       	call   80106988 <inb>
80106b0f:	0f b6 c0             	movzbl %al,%eax
80106b12:	83 e0 20             	and    $0x20,%eax
80106b15:	85 c0                	test   %eax,%eax
80106b17:	74 d4                	je     80106aed <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106b19:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1c:	0f b6 c0             	movzbl %al,%eax
80106b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b23:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b2a:	e8 76 fe ff ff       	call   801069a5 <outb>
}
80106b2f:	c9                   	leave  
80106b30:	c3                   	ret    

80106b31 <uartgetc>:

static int
uartgetc(void)
{
80106b31:	55                   	push   %ebp
80106b32:	89 e5                	mov    %esp,%ebp
80106b34:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106b37:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106b3c:	85 c0                	test   %eax,%eax
80106b3e:	75 07                	jne    80106b47 <uartgetc+0x16>
    return -1;
80106b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b45:	eb 2c                	jmp    80106b73 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106b47:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b4e:	e8 35 fe ff ff       	call   80106988 <inb>
80106b53:	0f b6 c0             	movzbl %al,%eax
80106b56:	83 e0 01             	and    $0x1,%eax
80106b59:	85 c0                	test   %eax,%eax
80106b5b:	75 07                	jne    80106b64 <uartgetc+0x33>
    return -1;
80106b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b62:	eb 0f                	jmp    80106b73 <uartgetc+0x42>
  return inb(COM1+0);
80106b64:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b6b:	e8 18 fe ff ff       	call   80106988 <inb>
80106b70:	0f b6 c0             	movzbl %al,%eax
}
80106b73:	c9                   	leave  
80106b74:	c3                   	ret    

80106b75 <uartintr>:

void
uartintr(void)
{
80106b75:	55                   	push   %ebp
80106b76:	89 e5                	mov    %esp,%ebp
80106b78:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106b7b:	c7 04 24 31 6b 10 80 	movl   $0x80106b31,(%esp)
80106b82:	e8 26 9c ff ff       	call   801007ad <consoleintr>
}
80106b87:	c9                   	leave  
80106b88:	c3                   	ret    

80106b89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $0
80106b8b:	6a 00                	push   $0x0
  jmp alltraps
80106b8d:	e9 7e f9 ff ff       	jmp    80106510 <alltraps>

80106b92 <vector1>:
.globl vector1
vector1:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $1
80106b94:	6a 01                	push   $0x1
  jmp alltraps
80106b96:	e9 75 f9 ff ff       	jmp    80106510 <alltraps>

80106b9b <vector2>:
.globl vector2
vector2:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $2
80106b9d:	6a 02                	push   $0x2
  jmp alltraps
80106b9f:	e9 6c f9 ff ff       	jmp    80106510 <alltraps>

80106ba4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $3
80106ba6:	6a 03                	push   $0x3
  jmp alltraps
80106ba8:	e9 63 f9 ff ff       	jmp    80106510 <alltraps>

80106bad <vector4>:
.globl vector4
vector4:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $4
80106baf:	6a 04                	push   $0x4
  jmp alltraps
80106bb1:	e9 5a f9 ff ff       	jmp    80106510 <alltraps>

80106bb6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $5
80106bb8:	6a 05                	push   $0x5
  jmp alltraps
80106bba:	e9 51 f9 ff ff       	jmp    80106510 <alltraps>

80106bbf <vector6>:
.globl vector6
vector6:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $6
80106bc1:	6a 06                	push   $0x6
  jmp alltraps
80106bc3:	e9 48 f9 ff ff       	jmp    80106510 <alltraps>

80106bc8 <vector7>:
.globl vector7
vector7:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $7
80106bca:	6a 07                	push   $0x7
  jmp alltraps
80106bcc:	e9 3f f9 ff ff       	jmp    80106510 <alltraps>

80106bd1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106bd1:	6a 08                	push   $0x8
  jmp alltraps
80106bd3:	e9 38 f9 ff ff       	jmp    80106510 <alltraps>

80106bd8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $9
80106bda:	6a 09                	push   $0x9
  jmp alltraps
80106bdc:	e9 2f f9 ff ff       	jmp    80106510 <alltraps>

80106be1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106be1:	6a 0a                	push   $0xa
  jmp alltraps
80106be3:	e9 28 f9 ff ff       	jmp    80106510 <alltraps>

80106be8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106be8:	6a 0b                	push   $0xb
  jmp alltraps
80106bea:	e9 21 f9 ff ff       	jmp    80106510 <alltraps>

80106bef <vector12>:
.globl vector12
vector12:
  pushl $12
80106bef:	6a 0c                	push   $0xc
  jmp alltraps
80106bf1:	e9 1a f9 ff ff       	jmp    80106510 <alltraps>

80106bf6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106bf6:	6a 0d                	push   $0xd
  jmp alltraps
80106bf8:	e9 13 f9 ff ff       	jmp    80106510 <alltraps>

80106bfd <vector14>:
.globl vector14
vector14:
  pushl $14
80106bfd:	6a 0e                	push   $0xe
  jmp alltraps
80106bff:	e9 0c f9 ff ff       	jmp    80106510 <alltraps>

80106c04 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $15
80106c06:	6a 0f                	push   $0xf
  jmp alltraps
80106c08:	e9 03 f9 ff ff       	jmp    80106510 <alltraps>

80106c0d <vector16>:
.globl vector16
vector16:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $16
80106c0f:	6a 10                	push   $0x10
  jmp alltraps
80106c11:	e9 fa f8 ff ff       	jmp    80106510 <alltraps>

80106c16 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c16:	6a 11                	push   $0x11
  jmp alltraps
80106c18:	e9 f3 f8 ff ff       	jmp    80106510 <alltraps>

80106c1d <vector18>:
.globl vector18
vector18:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $18
80106c1f:	6a 12                	push   $0x12
  jmp alltraps
80106c21:	e9 ea f8 ff ff       	jmp    80106510 <alltraps>

80106c26 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $19
80106c28:	6a 13                	push   $0x13
  jmp alltraps
80106c2a:	e9 e1 f8 ff ff       	jmp    80106510 <alltraps>

80106c2f <vector20>:
.globl vector20
vector20:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $20
80106c31:	6a 14                	push   $0x14
  jmp alltraps
80106c33:	e9 d8 f8 ff ff       	jmp    80106510 <alltraps>

80106c38 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $21
80106c3a:	6a 15                	push   $0x15
  jmp alltraps
80106c3c:	e9 cf f8 ff ff       	jmp    80106510 <alltraps>

80106c41 <vector22>:
.globl vector22
vector22:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $22
80106c43:	6a 16                	push   $0x16
  jmp alltraps
80106c45:	e9 c6 f8 ff ff       	jmp    80106510 <alltraps>

80106c4a <vector23>:
.globl vector23
vector23:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $23
80106c4c:	6a 17                	push   $0x17
  jmp alltraps
80106c4e:	e9 bd f8 ff ff       	jmp    80106510 <alltraps>

80106c53 <vector24>:
.globl vector24
vector24:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $24
80106c55:	6a 18                	push   $0x18
  jmp alltraps
80106c57:	e9 b4 f8 ff ff       	jmp    80106510 <alltraps>

80106c5c <vector25>:
.globl vector25
vector25:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $25
80106c5e:	6a 19                	push   $0x19
  jmp alltraps
80106c60:	e9 ab f8 ff ff       	jmp    80106510 <alltraps>

80106c65 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $26
80106c67:	6a 1a                	push   $0x1a
  jmp alltraps
80106c69:	e9 a2 f8 ff ff       	jmp    80106510 <alltraps>

80106c6e <vector27>:
.globl vector27
vector27:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $27
80106c70:	6a 1b                	push   $0x1b
  jmp alltraps
80106c72:	e9 99 f8 ff ff       	jmp    80106510 <alltraps>

80106c77 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $28
80106c79:	6a 1c                	push   $0x1c
  jmp alltraps
80106c7b:	e9 90 f8 ff ff       	jmp    80106510 <alltraps>

80106c80 <vector29>:
.globl vector29
vector29:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $29
80106c82:	6a 1d                	push   $0x1d
  jmp alltraps
80106c84:	e9 87 f8 ff ff       	jmp    80106510 <alltraps>

80106c89 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $30
80106c8b:	6a 1e                	push   $0x1e
  jmp alltraps
80106c8d:	e9 7e f8 ff ff       	jmp    80106510 <alltraps>

80106c92 <vector31>:
.globl vector31
vector31:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $31
80106c94:	6a 1f                	push   $0x1f
  jmp alltraps
80106c96:	e9 75 f8 ff ff       	jmp    80106510 <alltraps>

80106c9b <vector32>:
.globl vector32
vector32:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $32
80106c9d:	6a 20                	push   $0x20
  jmp alltraps
80106c9f:	e9 6c f8 ff ff       	jmp    80106510 <alltraps>

80106ca4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $33
80106ca6:	6a 21                	push   $0x21
  jmp alltraps
80106ca8:	e9 63 f8 ff ff       	jmp    80106510 <alltraps>

80106cad <vector34>:
.globl vector34
vector34:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $34
80106caf:	6a 22                	push   $0x22
  jmp alltraps
80106cb1:	e9 5a f8 ff ff       	jmp    80106510 <alltraps>

80106cb6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $35
80106cb8:	6a 23                	push   $0x23
  jmp alltraps
80106cba:	e9 51 f8 ff ff       	jmp    80106510 <alltraps>

80106cbf <vector36>:
.globl vector36
vector36:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $36
80106cc1:	6a 24                	push   $0x24
  jmp alltraps
80106cc3:	e9 48 f8 ff ff       	jmp    80106510 <alltraps>

80106cc8 <vector37>:
.globl vector37
vector37:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $37
80106cca:	6a 25                	push   $0x25
  jmp alltraps
80106ccc:	e9 3f f8 ff ff       	jmp    80106510 <alltraps>

80106cd1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $38
80106cd3:	6a 26                	push   $0x26
  jmp alltraps
80106cd5:	e9 36 f8 ff ff       	jmp    80106510 <alltraps>

80106cda <vector39>:
.globl vector39
vector39:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $39
80106cdc:	6a 27                	push   $0x27
  jmp alltraps
80106cde:	e9 2d f8 ff ff       	jmp    80106510 <alltraps>

80106ce3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $40
80106ce5:	6a 28                	push   $0x28
  jmp alltraps
80106ce7:	e9 24 f8 ff ff       	jmp    80106510 <alltraps>

80106cec <vector41>:
.globl vector41
vector41:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $41
80106cee:	6a 29                	push   $0x29
  jmp alltraps
80106cf0:	e9 1b f8 ff ff       	jmp    80106510 <alltraps>

80106cf5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $42
80106cf7:	6a 2a                	push   $0x2a
  jmp alltraps
80106cf9:	e9 12 f8 ff ff       	jmp    80106510 <alltraps>

80106cfe <vector43>:
.globl vector43
vector43:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $43
80106d00:	6a 2b                	push   $0x2b
  jmp alltraps
80106d02:	e9 09 f8 ff ff       	jmp    80106510 <alltraps>

80106d07 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $44
80106d09:	6a 2c                	push   $0x2c
  jmp alltraps
80106d0b:	e9 00 f8 ff ff       	jmp    80106510 <alltraps>

80106d10 <vector45>:
.globl vector45
vector45:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $45
80106d12:	6a 2d                	push   $0x2d
  jmp alltraps
80106d14:	e9 f7 f7 ff ff       	jmp    80106510 <alltraps>

80106d19 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $46
80106d1b:	6a 2e                	push   $0x2e
  jmp alltraps
80106d1d:	e9 ee f7 ff ff       	jmp    80106510 <alltraps>

80106d22 <vector47>:
.globl vector47
vector47:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $47
80106d24:	6a 2f                	push   $0x2f
  jmp alltraps
80106d26:	e9 e5 f7 ff ff       	jmp    80106510 <alltraps>

80106d2b <vector48>:
.globl vector48
vector48:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $48
80106d2d:	6a 30                	push   $0x30
  jmp alltraps
80106d2f:	e9 dc f7 ff ff       	jmp    80106510 <alltraps>

80106d34 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $49
80106d36:	6a 31                	push   $0x31
  jmp alltraps
80106d38:	e9 d3 f7 ff ff       	jmp    80106510 <alltraps>

80106d3d <vector50>:
.globl vector50
vector50:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $50
80106d3f:	6a 32                	push   $0x32
  jmp alltraps
80106d41:	e9 ca f7 ff ff       	jmp    80106510 <alltraps>

80106d46 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $51
80106d48:	6a 33                	push   $0x33
  jmp alltraps
80106d4a:	e9 c1 f7 ff ff       	jmp    80106510 <alltraps>

80106d4f <vector52>:
.globl vector52
vector52:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $52
80106d51:	6a 34                	push   $0x34
  jmp alltraps
80106d53:	e9 b8 f7 ff ff       	jmp    80106510 <alltraps>

80106d58 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $53
80106d5a:	6a 35                	push   $0x35
  jmp alltraps
80106d5c:	e9 af f7 ff ff       	jmp    80106510 <alltraps>

80106d61 <vector54>:
.globl vector54
vector54:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $54
80106d63:	6a 36                	push   $0x36
  jmp alltraps
80106d65:	e9 a6 f7 ff ff       	jmp    80106510 <alltraps>

80106d6a <vector55>:
.globl vector55
vector55:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $55
80106d6c:	6a 37                	push   $0x37
  jmp alltraps
80106d6e:	e9 9d f7 ff ff       	jmp    80106510 <alltraps>

80106d73 <vector56>:
.globl vector56
vector56:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $56
80106d75:	6a 38                	push   $0x38
  jmp alltraps
80106d77:	e9 94 f7 ff ff       	jmp    80106510 <alltraps>

80106d7c <vector57>:
.globl vector57
vector57:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $57
80106d7e:	6a 39                	push   $0x39
  jmp alltraps
80106d80:	e9 8b f7 ff ff       	jmp    80106510 <alltraps>

80106d85 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $58
80106d87:	6a 3a                	push   $0x3a
  jmp alltraps
80106d89:	e9 82 f7 ff ff       	jmp    80106510 <alltraps>

80106d8e <vector59>:
.globl vector59
vector59:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $59
80106d90:	6a 3b                	push   $0x3b
  jmp alltraps
80106d92:	e9 79 f7 ff ff       	jmp    80106510 <alltraps>

80106d97 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $60
80106d99:	6a 3c                	push   $0x3c
  jmp alltraps
80106d9b:	e9 70 f7 ff ff       	jmp    80106510 <alltraps>

80106da0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $61
80106da2:	6a 3d                	push   $0x3d
  jmp alltraps
80106da4:	e9 67 f7 ff ff       	jmp    80106510 <alltraps>

80106da9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $62
80106dab:	6a 3e                	push   $0x3e
  jmp alltraps
80106dad:	e9 5e f7 ff ff       	jmp    80106510 <alltraps>

80106db2 <vector63>:
.globl vector63
vector63:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $63
80106db4:	6a 3f                	push   $0x3f
  jmp alltraps
80106db6:	e9 55 f7 ff ff       	jmp    80106510 <alltraps>

80106dbb <vector64>:
.globl vector64
vector64:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $64
80106dbd:	6a 40                	push   $0x40
  jmp alltraps
80106dbf:	e9 4c f7 ff ff       	jmp    80106510 <alltraps>

80106dc4 <vector65>:
.globl vector65
vector65:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $65
80106dc6:	6a 41                	push   $0x41
  jmp alltraps
80106dc8:	e9 43 f7 ff ff       	jmp    80106510 <alltraps>

80106dcd <vector66>:
.globl vector66
vector66:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $66
80106dcf:	6a 42                	push   $0x42
  jmp alltraps
80106dd1:	e9 3a f7 ff ff       	jmp    80106510 <alltraps>

80106dd6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $67
80106dd8:	6a 43                	push   $0x43
  jmp alltraps
80106dda:	e9 31 f7 ff ff       	jmp    80106510 <alltraps>

80106ddf <vector68>:
.globl vector68
vector68:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $68
80106de1:	6a 44                	push   $0x44
  jmp alltraps
80106de3:	e9 28 f7 ff ff       	jmp    80106510 <alltraps>

80106de8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $69
80106dea:	6a 45                	push   $0x45
  jmp alltraps
80106dec:	e9 1f f7 ff ff       	jmp    80106510 <alltraps>

80106df1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $70
80106df3:	6a 46                	push   $0x46
  jmp alltraps
80106df5:	e9 16 f7 ff ff       	jmp    80106510 <alltraps>

80106dfa <vector71>:
.globl vector71
vector71:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $71
80106dfc:	6a 47                	push   $0x47
  jmp alltraps
80106dfe:	e9 0d f7 ff ff       	jmp    80106510 <alltraps>

80106e03 <vector72>:
.globl vector72
vector72:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $72
80106e05:	6a 48                	push   $0x48
  jmp alltraps
80106e07:	e9 04 f7 ff ff       	jmp    80106510 <alltraps>

80106e0c <vector73>:
.globl vector73
vector73:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $73
80106e0e:	6a 49                	push   $0x49
  jmp alltraps
80106e10:	e9 fb f6 ff ff       	jmp    80106510 <alltraps>

80106e15 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $74
80106e17:	6a 4a                	push   $0x4a
  jmp alltraps
80106e19:	e9 f2 f6 ff ff       	jmp    80106510 <alltraps>

80106e1e <vector75>:
.globl vector75
vector75:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $75
80106e20:	6a 4b                	push   $0x4b
  jmp alltraps
80106e22:	e9 e9 f6 ff ff       	jmp    80106510 <alltraps>

80106e27 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $76
80106e29:	6a 4c                	push   $0x4c
  jmp alltraps
80106e2b:	e9 e0 f6 ff ff       	jmp    80106510 <alltraps>

80106e30 <vector77>:
.globl vector77
vector77:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $77
80106e32:	6a 4d                	push   $0x4d
  jmp alltraps
80106e34:	e9 d7 f6 ff ff       	jmp    80106510 <alltraps>

80106e39 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $78
80106e3b:	6a 4e                	push   $0x4e
  jmp alltraps
80106e3d:	e9 ce f6 ff ff       	jmp    80106510 <alltraps>

80106e42 <vector79>:
.globl vector79
vector79:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $79
80106e44:	6a 4f                	push   $0x4f
  jmp alltraps
80106e46:	e9 c5 f6 ff ff       	jmp    80106510 <alltraps>

80106e4b <vector80>:
.globl vector80
vector80:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $80
80106e4d:	6a 50                	push   $0x50
  jmp alltraps
80106e4f:	e9 bc f6 ff ff       	jmp    80106510 <alltraps>

80106e54 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $81
80106e56:	6a 51                	push   $0x51
  jmp alltraps
80106e58:	e9 b3 f6 ff ff       	jmp    80106510 <alltraps>

80106e5d <vector82>:
.globl vector82
vector82:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $82
80106e5f:	6a 52                	push   $0x52
  jmp alltraps
80106e61:	e9 aa f6 ff ff       	jmp    80106510 <alltraps>

80106e66 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $83
80106e68:	6a 53                	push   $0x53
  jmp alltraps
80106e6a:	e9 a1 f6 ff ff       	jmp    80106510 <alltraps>

80106e6f <vector84>:
.globl vector84
vector84:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $84
80106e71:	6a 54                	push   $0x54
  jmp alltraps
80106e73:	e9 98 f6 ff ff       	jmp    80106510 <alltraps>

80106e78 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $85
80106e7a:	6a 55                	push   $0x55
  jmp alltraps
80106e7c:	e9 8f f6 ff ff       	jmp    80106510 <alltraps>

80106e81 <vector86>:
.globl vector86
vector86:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $86
80106e83:	6a 56                	push   $0x56
  jmp alltraps
80106e85:	e9 86 f6 ff ff       	jmp    80106510 <alltraps>

80106e8a <vector87>:
.globl vector87
vector87:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $87
80106e8c:	6a 57                	push   $0x57
  jmp alltraps
80106e8e:	e9 7d f6 ff ff       	jmp    80106510 <alltraps>

80106e93 <vector88>:
.globl vector88
vector88:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $88
80106e95:	6a 58                	push   $0x58
  jmp alltraps
80106e97:	e9 74 f6 ff ff       	jmp    80106510 <alltraps>

80106e9c <vector89>:
.globl vector89
vector89:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $89
80106e9e:	6a 59                	push   $0x59
  jmp alltraps
80106ea0:	e9 6b f6 ff ff       	jmp    80106510 <alltraps>

80106ea5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $90
80106ea7:	6a 5a                	push   $0x5a
  jmp alltraps
80106ea9:	e9 62 f6 ff ff       	jmp    80106510 <alltraps>

80106eae <vector91>:
.globl vector91
vector91:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $91
80106eb0:	6a 5b                	push   $0x5b
  jmp alltraps
80106eb2:	e9 59 f6 ff ff       	jmp    80106510 <alltraps>

80106eb7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $92
80106eb9:	6a 5c                	push   $0x5c
  jmp alltraps
80106ebb:	e9 50 f6 ff ff       	jmp    80106510 <alltraps>

80106ec0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $93
80106ec2:	6a 5d                	push   $0x5d
  jmp alltraps
80106ec4:	e9 47 f6 ff ff       	jmp    80106510 <alltraps>

80106ec9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $94
80106ecb:	6a 5e                	push   $0x5e
  jmp alltraps
80106ecd:	e9 3e f6 ff ff       	jmp    80106510 <alltraps>

80106ed2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $95
80106ed4:	6a 5f                	push   $0x5f
  jmp alltraps
80106ed6:	e9 35 f6 ff ff       	jmp    80106510 <alltraps>

80106edb <vector96>:
.globl vector96
vector96:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $96
80106edd:	6a 60                	push   $0x60
  jmp alltraps
80106edf:	e9 2c f6 ff ff       	jmp    80106510 <alltraps>

80106ee4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $97
80106ee6:	6a 61                	push   $0x61
  jmp alltraps
80106ee8:	e9 23 f6 ff ff       	jmp    80106510 <alltraps>

80106eed <vector98>:
.globl vector98
vector98:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $98
80106eef:	6a 62                	push   $0x62
  jmp alltraps
80106ef1:	e9 1a f6 ff ff       	jmp    80106510 <alltraps>

80106ef6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $99
80106ef8:	6a 63                	push   $0x63
  jmp alltraps
80106efa:	e9 11 f6 ff ff       	jmp    80106510 <alltraps>

80106eff <vector100>:
.globl vector100
vector100:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $100
80106f01:	6a 64                	push   $0x64
  jmp alltraps
80106f03:	e9 08 f6 ff ff       	jmp    80106510 <alltraps>

80106f08 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $101
80106f0a:	6a 65                	push   $0x65
  jmp alltraps
80106f0c:	e9 ff f5 ff ff       	jmp    80106510 <alltraps>

80106f11 <vector102>:
.globl vector102
vector102:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $102
80106f13:	6a 66                	push   $0x66
  jmp alltraps
80106f15:	e9 f6 f5 ff ff       	jmp    80106510 <alltraps>

80106f1a <vector103>:
.globl vector103
vector103:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $103
80106f1c:	6a 67                	push   $0x67
  jmp alltraps
80106f1e:	e9 ed f5 ff ff       	jmp    80106510 <alltraps>

80106f23 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $104
80106f25:	6a 68                	push   $0x68
  jmp alltraps
80106f27:	e9 e4 f5 ff ff       	jmp    80106510 <alltraps>

80106f2c <vector105>:
.globl vector105
vector105:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $105
80106f2e:	6a 69                	push   $0x69
  jmp alltraps
80106f30:	e9 db f5 ff ff       	jmp    80106510 <alltraps>

80106f35 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $106
80106f37:	6a 6a                	push   $0x6a
  jmp alltraps
80106f39:	e9 d2 f5 ff ff       	jmp    80106510 <alltraps>

80106f3e <vector107>:
.globl vector107
vector107:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $107
80106f40:	6a 6b                	push   $0x6b
  jmp alltraps
80106f42:	e9 c9 f5 ff ff       	jmp    80106510 <alltraps>

80106f47 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $108
80106f49:	6a 6c                	push   $0x6c
  jmp alltraps
80106f4b:	e9 c0 f5 ff ff       	jmp    80106510 <alltraps>

80106f50 <vector109>:
.globl vector109
vector109:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $109
80106f52:	6a 6d                	push   $0x6d
  jmp alltraps
80106f54:	e9 b7 f5 ff ff       	jmp    80106510 <alltraps>

80106f59 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $110
80106f5b:	6a 6e                	push   $0x6e
  jmp alltraps
80106f5d:	e9 ae f5 ff ff       	jmp    80106510 <alltraps>

80106f62 <vector111>:
.globl vector111
vector111:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $111
80106f64:	6a 6f                	push   $0x6f
  jmp alltraps
80106f66:	e9 a5 f5 ff ff       	jmp    80106510 <alltraps>

80106f6b <vector112>:
.globl vector112
vector112:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $112
80106f6d:	6a 70                	push   $0x70
  jmp alltraps
80106f6f:	e9 9c f5 ff ff       	jmp    80106510 <alltraps>

80106f74 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $113
80106f76:	6a 71                	push   $0x71
  jmp alltraps
80106f78:	e9 93 f5 ff ff       	jmp    80106510 <alltraps>

80106f7d <vector114>:
.globl vector114
vector114:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $114
80106f7f:	6a 72                	push   $0x72
  jmp alltraps
80106f81:	e9 8a f5 ff ff       	jmp    80106510 <alltraps>

80106f86 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $115
80106f88:	6a 73                	push   $0x73
  jmp alltraps
80106f8a:	e9 81 f5 ff ff       	jmp    80106510 <alltraps>

80106f8f <vector116>:
.globl vector116
vector116:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $116
80106f91:	6a 74                	push   $0x74
  jmp alltraps
80106f93:	e9 78 f5 ff ff       	jmp    80106510 <alltraps>

80106f98 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $117
80106f9a:	6a 75                	push   $0x75
  jmp alltraps
80106f9c:	e9 6f f5 ff ff       	jmp    80106510 <alltraps>

80106fa1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $118
80106fa3:	6a 76                	push   $0x76
  jmp alltraps
80106fa5:	e9 66 f5 ff ff       	jmp    80106510 <alltraps>

80106faa <vector119>:
.globl vector119
vector119:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $119
80106fac:	6a 77                	push   $0x77
  jmp alltraps
80106fae:	e9 5d f5 ff ff       	jmp    80106510 <alltraps>

80106fb3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $120
80106fb5:	6a 78                	push   $0x78
  jmp alltraps
80106fb7:	e9 54 f5 ff ff       	jmp    80106510 <alltraps>

80106fbc <vector121>:
.globl vector121
vector121:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $121
80106fbe:	6a 79                	push   $0x79
  jmp alltraps
80106fc0:	e9 4b f5 ff ff       	jmp    80106510 <alltraps>

80106fc5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $122
80106fc7:	6a 7a                	push   $0x7a
  jmp alltraps
80106fc9:	e9 42 f5 ff ff       	jmp    80106510 <alltraps>

80106fce <vector123>:
.globl vector123
vector123:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $123
80106fd0:	6a 7b                	push   $0x7b
  jmp alltraps
80106fd2:	e9 39 f5 ff ff       	jmp    80106510 <alltraps>

80106fd7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $124
80106fd9:	6a 7c                	push   $0x7c
  jmp alltraps
80106fdb:	e9 30 f5 ff ff       	jmp    80106510 <alltraps>

80106fe0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $125
80106fe2:	6a 7d                	push   $0x7d
  jmp alltraps
80106fe4:	e9 27 f5 ff ff       	jmp    80106510 <alltraps>

80106fe9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $126
80106feb:	6a 7e                	push   $0x7e
  jmp alltraps
80106fed:	e9 1e f5 ff ff       	jmp    80106510 <alltraps>

80106ff2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $127
80106ff4:	6a 7f                	push   $0x7f
  jmp alltraps
80106ff6:	e9 15 f5 ff ff       	jmp    80106510 <alltraps>

80106ffb <vector128>:
.globl vector128
vector128:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $128
80106ffd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107002:	e9 09 f5 ff ff       	jmp    80106510 <alltraps>

80107007 <vector129>:
.globl vector129
vector129:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $129
80107009:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010700e:	e9 fd f4 ff ff       	jmp    80106510 <alltraps>

80107013 <vector130>:
.globl vector130
vector130:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $130
80107015:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010701a:	e9 f1 f4 ff ff       	jmp    80106510 <alltraps>

8010701f <vector131>:
.globl vector131
vector131:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $131
80107021:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107026:	e9 e5 f4 ff ff       	jmp    80106510 <alltraps>

8010702b <vector132>:
.globl vector132
vector132:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $132
8010702d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107032:	e9 d9 f4 ff ff       	jmp    80106510 <alltraps>

80107037 <vector133>:
.globl vector133
vector133:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $133
80107039:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010703e:	e9 cd f4 ff ff       	jmp    80106510 <alltraps>

80107043 <vector134>:
.globl vector134
vector134:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $134
80107045:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010704a:	e9 c1 f4 ff ff       	jmp    80106510 <alltraps>

8010704f <vector135>:
.globl vector135
vector135:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $135
80107051:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107056:	e9 b5 f4 ff ff       	jmp    80106510 <alltraps>

8010705b <vector136>:
.globl vector136
vector136:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $136
8010705d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107062:	e9 a9 f4 ff ff       	jmp    80106510 <alltraps>

80107067 <vector137>:
.globl vector137
vector137:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $137
80107069:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010706e:	e9 9d f4 ff ff       	jmp    80106510 <alltraps>

80107073 <vector138>:
.globl vector138
vector138:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $138
80107075:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010707a:	e9 91 f4 ff ff       	jmp    80106510 <alltraps>

8010707f <vector139>:
.globl vector139
vector139:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $139
80107081:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107086:	e9 85 f4 ff ff       	jmp    80106510 <alltraps>

8010708b <vector140>:
.globl vector140
vector140:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $140
8010708d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107092:	e9 79 f4 ff ff       	jmp    80106510 <alltraps>

80107097 <vector141>:
.globl vector141
vector141:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $141
80107099:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010709e:	e9 6d f4 ff ff       	jmp    80106510 <alltraps>

801070a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $142
801070a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070aa:	e9 61 f4 ff ff       	jmp    80106510 <alltraps>

801070af <vector143>:
.globl vector143
vector143:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $143
801070b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801070b6:	e9 55 f4 ff ff       	jmp    80106510 <alltraps>

801070bb <vector144>:
.globl vector144
vector144:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $144
801070bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801070c2:	e9 49 f4 ff ff       	jmp    80106510 <alltraps>

801070c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $145
801070c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801070ce:	e9 3d f4 ff ff       	jmp    80106510 <alltraps>

801070d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $146
801070d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801070da:	e9 31 f4 ff ff       	jmp    80106510 <alltraps>

801070df <vector147>:
.globl vector147
vector147:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $147
801070e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801070e6:	e9 25 f4 ff ff       	jmp    80106510 <alltraps>

801070eb <vector148>:
.globl vector148
vector148:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $148
801070ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801070f2:	e9 19 f4 ff ff       	jmp    80106510 <alltraps>

801070f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $149
801070f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801070fe:	e9 0d f4 ff ff       	jmp    80106510 <alltraps>

80107103 <vector150>:
.globl vector150
vector150:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $150
80107105:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010710a:	e9 01 f4 ff ff       	jmp    80106510 <alltraps>

8010710f <vector151>:
.globl vector151
vector151:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $151
80107111:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107116:	e9 f5 f3 ff ff       	jmp    80106510 <alltraps>

8010711b <vector152>:
.globl vector152
vector152:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $152
8010711d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107122:	e9 e9 f3 ff ff       	jmp    80106510 <alltraps>

80107127 <vector153>:
.globl vector153
vector153:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $153
80107129:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010712e:	e9 dd f3 ff ff       	jmp    80106510 <alltraps>

80107133 <vector154>:
.globl vector154
vector154:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $154
80107135:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010713a:	e9 d1 f3 ff ff       	jmp    80106510 <alltraps>

8010713f <vector155>:
.globl vector155
vector155:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $155
80107141:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107146:	e9 c5 f3 ff ff       	jmp    80106510 <alltraps>

8010714b <vector156>:
.globl vector156
vector156:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $156
8010714d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107152:	e9 b9 f3 ff ff       	jmp    80106510 <alltraps>

80107157 <vector157>:
.globl vector157
vector157:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $157
80107159:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010715e:	e9 ad f3 ff ff       	jmp    80106510 <alltraps>

80107163 <vector158>:
.globl vector158
vector158:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $158
80107165:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010716a:	e9 a1 f3 ff ff       	jmp    80106510 <alltraps>

8010716f <vector159>:
.globl vector159
vector159:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $159
80107171:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107176:	e9 95 f3 ff ff       	jmp    80106510 <alltraps>

8010717b <vector160>:
.globl vector160
vector160:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $160
8010717d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107182:	e9 89 f3 ff ff       	jmp    80106510 <alltraps>

80107187 <vector161>:
.globl vector161
vector161:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $161
80107189:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010718e:	e9 7d f3 ff ff       	jmp    80106510 <alltraps>

80107193 <vector162>:
.globl vector162
vector162:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $162
80107195:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010719a:	e9 71 f3 ff ff       	jmp    80106510 <alltraps>

8010719f <vector163>:
.globl vector163
vector163:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $163
801071a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071a6:	e9 65 f3 ff ff       	jmp    80106510 <alltraps>

801071ab <vector164>:
.globl vector164
vector164:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $164
801071ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801071b2:	e9 59 f3 ff ff       	jmp    80106510 <alltraps>

801071b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $165
801071b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801071be:	e9 4d f3 ff ff       	jmp    80106510 <alltraps>

801071c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $166
801071c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801071ca:	e9 41 f3 ff ff       	jmp    80106510 <alltraps>

801071cf <vector167>:
.globl vector167
vector167:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $167
801071d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801071d6:	e9 35 f3 ff ff       	jmp    80106510 <alltraps>

801071db <vector168>:
.globl vector168
vector168:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $168
801071dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801071e2:	e9 29 f3 ff ff       	jmp    80106510 <alltraps>

801071e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $169
801071e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801071ee:	e9 1d f3 ff ff       	jmp    80106510 <alltraps>

801071f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $170
801071f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801071fa:	e9 11 f3 ff ff       	jmp    80106510 <alltraps>

801071ff <vector171>:
.globl vector171
vector171:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $171
80107201:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107206:	e9 05 f3 ff ff       	jmp    80106510 <alltraps>

8010720b <vector172>:
.globl vector172
vector172:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $172
8010720d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107212:	e9 f9 f2 ff ff       	jmp    80106510 <alltraps>

80107217 <vector173>:
.globl vector173
vector173:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $173
80107219:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010721e:	e9 ed f2 ff ff       	jmp    80106510 <alltraps>

80107223 <vector174>:
.globl vector174
vector174:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $174
80107225:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010722a:	e9 e1 f2 ff ff       	jmp    80106510 <alltraps>

8010722f <vector175>:
.globl vector175
vector175:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $175
80107231:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107236:	e9 d5 f2 ff ff       	jmp    80106510 <alltraps>

8010723b <vector176>:
.globl vector176
vector176:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $176
8010723d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107242:	e9 c9 f2 ff ff       	jmp    80106510 <alltraps>

80107247 <vector177>:
.globl vector177
vector177:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $177
80107249:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010724e:	e9 bd f2 ff ff       	jmp    80106510 <alltraps>

80107253 <vector178>:
.globl vector178
vector178:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $178
80107255:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010725a:	e9 b1 f2 ff ff       	jmp    80106510 <alltraps>

8010725f <vector179>:
.globl vector179
vector179:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $179
80107261:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107266:	e9 a5 f2 ff ff       	jmp    80106510 <alltraps>

8010726b <vector180>:
.globl vector180
vector180:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $180
8010726d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107272:	e9 99 f2 ff ff       	jmp    80106510 <alltraps>

80107277 <vector181>:
.globl vector181
vector181:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $181
80107279:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010727e:	e9 8d f2 ff ff       	jmp    80106510 <alltraps>

80107283 <vector182>:
.globl vector182
vector182:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $182
80107285:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010728a:	e9 81 f2 ff ff       	jmp    80106510 <alltraps>

8010728f <vector183>:
.globl vector183
vector183:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $183
80107291:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107296:	e9 75 f2 ff ff       	jmp    80106510 <alltraps>

8010729b <vector184>:
.globl vector184
vector184:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $184
8010729d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072a2:	e9 69 f2 ff ff       	jmp    80106510 <alltraps>

801072a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $185
801072a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801072ae:	e9 5d f2 ff ff       	jmp    80106510 <alltraps>

801072b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $186
801072b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801072ba:	e9 51 f2 ff ff       	jmp    80106510 <alltraps>

801072bf <vector187>:
.globl vector187
vector187:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $187
801072c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801072c6:	e9 45 f2 ff ff       	jmp    80106510 <alltraps>

801072cb <vector188>:
.globl vector188
vector188:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $188
801072cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801072d2:	e9 39 f2 ff ff       	jmp    80106510 <alltraps>

801072d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $189
801072d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801072de:	e9 2d f2 ff ff       	jmp    80106510 <alltraps>

801072e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $190
801072e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801072ea:	e9 21 f2 ff ff       	jmp    80106510 <alltraps>

801072ef <vector191>:
.globl vector191
vector191:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $191
801072f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801072f6:	e9 15 f2 ff ff       	jmp    80106510 <alltraps>

801072fb <vector192>:
.globl vector192
vector192:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $192
801072fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107302:	e9 09 f2 ff ff       	jmp    80106510 <alltraps>

80107307 <vector193>:
.globl vector193
vector193:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $193
80107309:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010730e:	e9 fd f1 ff ff       	jmp    80106510 <alltraps>

80107313 <vector194>:
.globl vector194
vector194:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $194
80107315:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010731a:	e9 f1 f1 ff ff       	jmp    80106510 <alltraps>

8010731f <vector195>:
.globl vector195
vector195:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $195
80107321:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107326:	e9 e5 f1 ff ff       	jmp    80106510 <alltraps>

8010732b <vector196>:
.globl vector196
vector196:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $196
8010732d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107332:	e9 d9 f1 ff ff       	jmp    80106510 <alltraps>

80107337 <vector197>:
.globl vector197
vector197:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $197
80107339:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010733e:	e9 cd f1 ff ff       	jmp    80106510 <alltraps>

80107343 <vector198>:
.globl vector198
vector198:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $198
80107345:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010734a:	e9 c1 f1 ff ff       	jmp    80106510 <alltraps>

8010734f <vector199>:
.globl vector199
vector199:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $199
80107351:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107356:	e9 b5 f1 ff ff       	jmp    80106510 <alltraps>

8010735b <vector200>:
.globl vector200
vector200:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $200
8010735d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107362:	e9 a9 f1 ff ff       	jmp    80106510 <alltraps>

80107367 <vector201>:
.globl vector201
vector201:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $201
80107369:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010736e:	e9 9d f1 ff ff       	jmp    80106510 <alltraps>

80107373 <vector202>:
.globl vector202
vector202:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $202
80107375:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010737a:	e9 91 f1 ff ff       	jmp    80106510 <alltraps>

8010737f <vector203>:
.globl vector203
vector203:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $203
80107381:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107386:	e9 85 f1 ff ff       	jmp    80106510 <alltraps>

8010738b <vector204>:
.globl vector204
vector204:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $204
8010738d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107392:	e9 79 f1 ff ff       	jmp    80106510 <alltraps>

80107397 <vector205>:
.globl vector205
vector205:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $205
80107399:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010739e:	e9 6d f1 ff ff       	jmp    80106510 <alltraps>

801073a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $206
801073a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073aa:	e9 61 f1 ff ff       	jmp    80106510 <alltraps>

801073af <vector207>:
.globl vector207
vector207:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $207
801073b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801073b6:	e9 55 f1 ff ff       	jmp    80106510 <alltraps>

801073bb <vector208>:
.globl vector208
vector208:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $208
801073bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801073c2:	e9 49 f1 ff ff       	jmp    80106510 <alltraps>

801073c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $209
801073c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801073ce:	e9 3d f1 ff ff       	jmp    80106510 <alltraps>

801073d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $210
801073d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801073da:	e9 31 f1 ff ff       	jmp    80106510 <alltraps>

801073df <vector211>:
.globl vector211
vector211:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $211
801073e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801073e6:	e9 25 f1 ff ff       	jmp    80106510 <alltraps>

801073eb <vector212>:
.globl vector212
vector212:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $212
801073ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801073f2:	e9 19 f1 ff ff       	jmp    80106510 <alltraps>

801073f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $213
801073f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801073fe:	e9 0d f1 ff ff       	jmp    80106510 <alltraps>

80107403 <vector214>:
.globl vector214
vector214:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $214
80107405:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010740a:	e9 01 f1 ff ff       	jmp    80106510 <alltraps>

8010740f <vector215>:
.globl vector215
vector215:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $215
80107411:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107416:	e9 f5 f0 ff ff       	jmp    80106510 <alltraps>

8010741b <vector216>:
.globl vector216
vector216:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $216
8010741d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107422:	e9 e9 f0 ff ff       	jmp    80106510 <alltraps>

80107427 <vector217>:
.globl vector217
vector217:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $217
80107429:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010742e:	e9 dd f0 ff ff       	jmp    80106510 <alltraps>

80107433 <vector218>:
.globl vector218
vector218:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $218
80107435:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010743a:	e9 d1 f0 ff ff       	jmp    80106510 <alltraps>

8010743f <vector219>:
.globl vector219
vector219:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $219
80107441:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107446:	e9 c5 f0 ff ff       	jmp    80106510 <alltraps>

8010744b <vector220>:
.globl vector220
vector220:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $220
8010744d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107452:	e9 b9 f0 ff ff       	jmp    80106510 <alltraps>

80107457 <vector221>:
.globl vector221
vector221:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $221
80107459:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010745e:	e9 ad f0 ff ff       	jmp    80106510 <alltraps>

80107463 <vector222>:
.globl vector222
vector222:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $222
80107465:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010746a:	e9 a1 f0 ff ff       	jmp    80106510 <alltraps>

8010746f <vector223>:
.globl vector223
vector223:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $223
80107471:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107476:	e9 95 f0 ff ff       	jmp    80106510 <alltraps>

8010747b <vector224>:
.globl vector224
vector224:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $224
8010747d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107482:	e9 89 f0 ff ff       	jmp    80106510 <alltraps>

80107487 <vector225>:
.globl vector225
vector225:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $225
80107489:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010748e:	e9 7d f0 ff ff       	jmp    80106510 <alltraps>

80107493 <vector226>:
.globl vector226
vector226:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $226
80107495:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010749a:	e9 71 f0 ff ff       	jmp    80106510 <alltraps>

8010749f <vector227>:
.globl vector227
vector227:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $227
801074a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074a6:	e9 65 f0 ff ff       	jmp    80106510 <alltraps>

801074ab <vector228>:
.globl vector228
vector228:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $228
801074ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801074b2:	e9 59 f0 ff ff       	jmp    80106510 <alltraps>

801074b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $229
801074b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801074be:	e9 4d f0 ff ff       	jmp    80106510 <alltraps>

801074c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $230
801074c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801074ca:	e9 41 f0 ff ff       	jmp    80106510 <alltraps>

801074cf <vector231>:
.globl vector231
vector231:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $231
801074d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801074d6:	e9 35 f0 ff ff       	jmp    80106510 <alltraps>

801074db <vector232>:
.globl vector232
vector232:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $232
801074dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801074e2:	e9 29 f0 ff ff       	jmp    80106510 <alltraps>

801074e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $233
801074e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801074ee:	e9 1d f0 ff ff       	jmp    80106510 <alltraps>

801074f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $234
801074f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801074fa:	e9 11 f0 ff ff       	jmp    80106510 <alltraps>

801074ff <vector235>:
.globl vector235
vector235:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $235
80107501:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107506:	e9 05 f0 ff ff       	jmp    80106510 <alltraps>

8010750b <vector236>:
.globl vector236
vector236:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $236
8010750d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107512:	e9 f9 ef ff ff       	jmp    80106510 <alltraps>

80107517 <vector237>:
.globl vector237
vector237:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $237
80107519:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010751e:	e9 ed ef ff ff       	jmp    80106510 <alltraps>

80107523 <vector238>:
.globl vector238
vector238:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $238
80107525:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010752a:	e9 e1 ef ff ff       	jmp    80106510 <alltraps>

8010752f <vector239>:
.globl vector239
vector239:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $239
80107531:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107536:	e9 d5 ef ff ff       	jmp    80106510 <alltraps>

8010753b <vector240>:
.globl vector240
vector240:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $240
8010753d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107542:	e9 c9 ef ff ff       	jmp    80106510 <alltraps>

80107547 <vector241>:
.globl vector241
vector241:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $241
80107549:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010754e:	e9 bd ef ff ff       	jmp    80106510 <alltraps>

80107553 <vector242>:
.globl vector242
vector242:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $242
80107555:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010755a:	e9 b1 ef ff ff       	jmp    80106510 <alltraps>

8010755f <vector243>:
.globl vector243
vector243:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $243
80107561:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107566:	e9 a5 ef ff ff       	jmp    80106510 <alltraps>

8010756b <vector244>:
.globl vector244
vector244:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $244
8010756d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107572:	e9 99 ef ff ff       	jmp    80106510 <alltraps>

80107577 <vector245>:
.globl vector245
vector245:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $245
80107579:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010757e:	e9 8d ef ff ff       	jmp    80106510 <alltraps>

80107583 <vector246>:
.globl vector246
vector246:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $246
80107585:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010758a:	e9 81 ef ff ff       	jmp    80106510 <alltraps>

8010758f <vector247>:
.globl vector247
vector247:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $247
80107591:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107596:	e9 75 ef ff ff       	jmp    80106510 <alltraps>

8010759b <vector248>:
.globl vector248
vector248:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $248
8010759d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075a2:	e9 69 ef ff ff       	jmp    80106510 <alltraps>

801075a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $249
801075a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801075ae:	e9 5d ef ff ff       	jmp    80106510 <alltraps>

801075b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $250
801075b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801075ba:	e9 51 ef ff ff       	jmp    80106510 <alltraps>

801075bf <vector251>:
.globl vector251
vector251:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $251
801075c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801075c6:	e9 45 ef ff ff       	jmp    80106510 <alltraps>

801075cb <vector252>:
.globl vector252
vector252:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $252
801075cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801075d2:	e9 39 ef ff ff       	jmp    80106510 <alltraps>

801075d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $253
801075d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801075de:	e9 2d ef ff ff       	jmp    80106510 <alltraps>

801075e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $254
801075e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801075ea:	e9 21 ef ff ff       	jmp    80106510 <alltraps>

801075ef <vector255>:
.globl vector255
vector255:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $255
801075f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801075f6:	e9 15 ef ff ff       	jmp    80106510 <alltraps>

801075fb <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801075fb:	55                   	push   %ebp
801075fc:	89 e5                	mov    %esp,%ebp
801075fe:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107601:	8b 45 0c             	mov    0xc(%ebp),%eax
80107604:	83 e8 01             	sub    $0x1,%eax
80107607:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010760b:	8b 45 08             	mov    0x8(%ebp),%eax
8010760e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107612:	8b 45 08             	mov    0x8(%ebp),%eax
80107615:	c1 e8 10             	shr    $0x10,%eax
80107618:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010761c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010761f:	0f 01 10             	lgdtl  (%eax)
}
80107622:	c9                   	leave  
80107623:	c3                   	ret    

80107624 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	83 ec 04             	sub    $0x4,%esp
8010762a:	8b 45 08             	mov    0x8(%ebp),%eax
8010762d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107631:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107635:	0f 00 d8             	ltr    %ax
}
80107638:	c9                   	leave  
80107639:	c3                   	ret    

8010763a <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010763a:	55                   	push   %ebp
8010763b:	89 e5                	mov    %esp,%ebp
8010763d:	83 ec 04             	sub    $0x4,%esp
80107640:	8b 45 08             	mov    0x8(%ebp),%eax
80107643:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107647:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010764b:	8e e8                	mov    %eax,%gs
}
8010764d:	c9                   	leave  
8010764e:	c3                   	ret    

8010764f <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010764f:	55                   	push   %ebp
80107650:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107652:	8b 45 08             	mov    0x8(%ebp),%eax
80107655:	0f 22 d8             	mov    %eax,%cr3
}
80107658:	5d                   	pop    %ebp
80107659:	c3                   	ret    

8010765a <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010765a:	55                   	push   %ebp
8010765b:	89 e5                	mov    %esp,%ebp
8010765d:	8b 45 08             	mov    0x8(%ebp),%eax
80107660:	05 00 00 00 80       	add    $0x80000000,%eax
80107665:	5d                   	pop    %ebp
80107666:	c3                   	ret    

80107667 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107667:	55                   	push   %ebp
80107668:	89 e5                	mov    %esp,%ebp
8010766a:	8b 45 08             	mov    0x8(%ebp),%eax
8010766d:	05 00 00 00 80       	add    $0x80000000,%eax
80107672:	5d                   	pop    %ebp
80107673:	c3                   	ret    

80107674 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107674:	55                   	push   %ebp
80107675:	89 e5                	mov    %esp,%ebp
80107677:	53                   	push   %ebx
80107678:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010767b:	e8 93 b8 ff ff       	call   80102f13 <cpunum>
80107680:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107686:	05 80 23 11 80       	add    $0x80112380,%eax
8010768b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010768e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107691:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801076a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a3:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801076a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076aa:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076ae:	83 e2 f0             	and    $0xfffffff0,%edx
801076b1:	83 ca 0a             	or     $0xa,%edx
801076b4:	88 50 7d             	mov    %dl,0x7d(%eax)
801076b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ba:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076be:	83 ca 10             	or     $0x10,%edx
801076c1:	88 50 7d             	mov    %dl,0x7d(%eax)
801076c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076cb:	83 e2 9f             	and    $0xffffff9f,%edx
801076ce:	88 50 7d             	mov    %dl,0x7d(%eax)
801076d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801076d8:	83 ca 80             	or     $0xffffff80,%edx
801076db:	88 50 7d             	mov    %dl,0x7d(%eax)
801076de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076e5:	83 ca 0f             	or     $0xf,%edx
801076e8:	88 50 7e             	mov    %dl,0x7e(%eax)
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076f2:	83 e2 ef             	and    $0xffffffef,%edx
801076f5:	88 50 7e             	mov    %dl,0x7e(%eax)
801076f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801076ff:	83 e2 df             	and    $0xffffffdf,%edx
80107702:	88 50 7e             	mov    %dl,0x7e(%eax)
80107705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107708:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010770c:	83 ca 40             	or     $0x40,%edx
8010770f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107715:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107719:	83 ca 80             	or     $0xffffff80,%edx
8010771c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010771f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107722:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107729:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107730:	ff ff 
80107732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107735:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010773c:	00 00 
8010773e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107741:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107752:	83 e2 f0             	and    $0xfffffff0,%edx
80107755:	83 ca 02             	or     $0x2,%edx
80107758:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010775e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107761:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107768:	83 ca 10             	or     $0x10,%edx
8010776b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107774:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010777b:	83 e2 9f             	and    $0xffffff9f,%edx
8010777e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107787:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010778e:	83 ca 80             	or     $0xffffff80,%edx
80107791:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077a1:	83 ca 0f             	or     $0xf,%edx
801077a4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ad:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077b4:	83 e2 ef             	and    $0xffffffef,%edx
801077b7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077c7:	83 e2 df             	and    $0xffffffdf,%edx
801077ca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077da:	83 ca 40             	or     $0x40,%edx
801077dd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077ed:	83 ca 80             	or     $0xffffff80,%edx
801077f0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f9:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107803:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010780a:	ff ff 
8010780c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780f:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107816:	00 00 
80107818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781b:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107825:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010782c:	83 e2 f0             	and    $0xfffffff0,%edx
8010782f:	83 ca 0a             	or     $0xa,%edx
80107832:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107842:	83 ca 10             	or     $0x10,%edx
80107845:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010784b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107855:	83 ca 60             	or     $0x60,%edx
80107858:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010785e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107861:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107868:	83 ca 80             	or     $0xffffff80,%edx
8010786b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107874:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010787b:	83 ca 0f             	or     $0xf,%edx
8010787e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107887:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010788e:	83 e2 ef             	and    $0xffffffef,%edx
80107891:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078a1:	83 e2 df             	and    $0xffffffdf,%edx
801078a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ad:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078b4:	83 ca 40             	or     $0x40,%edx
801078b7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078c7:	83 ca 80             	or     $0xffffff80,%edx
801078ca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d3:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801078da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078dd:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801078e4:	ff ff 
801078e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e9:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801078f0:	00 00 
801078f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f5:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801078fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ff:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107906:	83 e2 f0             	and    $0xfffffff0,%edx
80107909:	83 ca 02             	or     $0x2,%edx
8010790c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107915:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010791c:	83 ca 10             	or     $0x10,%edx
8010791f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107928:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010792f:	83 ca 60             	or     $0x60,%edx
80107932:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107942:	83 ca 80             	or     $0xffffff80,%edx
80107945:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010794b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107955:	83 ca 0f             	or     $0xf,%edx
80107958:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010795e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107961:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107968:	83 e2 ef             	and    $0xffffffef,%edx
8010796b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107974:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010797b:	83 e2 df             	and    $0xffffffdf,%edx
8010797e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107987:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010798e:	83 ca 40             	or     $0x40,%edx
80107991:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079a1:	83 ca 80             	or     $0xffffff80,%edx
801079a4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801079b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b7:	05 b4 00 00 00       	add    $0xb4,%eax
801079bc:	89 c3                	mov    %eax,%ebx
801079be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c1:	05 b4 00 00 00       	add    $0xb4,%eax
801079c6:	c1 e8 10             	shr    $0x10,%eax
801079c9:	89 c1                	mov    %eax,%ecx
801079cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ce:	05 b4 00 00 00       	add    $0xb4,%eax
801079d3:	c1 e8 18             	shr    $0x18,%eax
801079d6:	89 c2                	mov    %eax,%edx
801079d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079db:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801079e2:	00 00 
801079e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e7:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801079ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f1:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801079f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fa:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a01:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a04:	83 c9 02             	or     $0x2,%ecx
80107a07:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a10:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a17:	83 c9 10             	or     $0x10,%ecx
80107a1a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a23:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a2a:	83 e1 9f             	and    $0xffffff9f,%ecx
80107a2d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a36:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a3d:	83 c9 80             	or     $0xffffff80,%ecx
80107a40:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a49:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a50:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a53:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a63:	83 e1 ef             	and    $0xffffffef,%ecx
80107a66:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a76:	83 e1 df             	and    $0xffffffdf,%ecx
80107a79:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a82:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a89:	83 c9 40             	or     $0x40,%ecx
80107a8c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a95:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107a9c:	83 c9 80             	or     $0xffffff80,%ecx
80107a9f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa8:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab1:	83 c0 70             	add    $0x70,%eax
80107ab4:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107abb:	00 
80107abc:	89 04 24             	mov    %eax,(%esp)
80107abf:	e8 37 fb ff ff       	call   801075fb <lgdt>
  loadgs(SEG_KCPU << 3);
80107ac4:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107acb:	e8 6a fb ff ff       	call   8010763a <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad3:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107ad9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107ae0:	00 00 00 00 
}
80107ae4:	83 c4 24             	add    $0x24,%esp
80107ae7:	5b                   	pop    %ebx
80107ae8:	5d                   	pop    %ebp
80107ae9:	c3                   	ret    

80107aea <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107aea:	55                   	push   %ebp
80107aeb:	89 e5                	mov    %esp,%ebp
80107aed:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107af3:	c1 e8 16             	shr    $0x16,%eax
80107af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107afd:	8b 45 08             	mov    0x8(%ebp),%eax
80107b00:	01 d0                	add    %edx,%eax
80107b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b08:	8b 00                	mov    (%eax),%eax
80107b0a:	83 e0 01             	and    $0x1,%eax
80107b0d:	85 c0                	test   %eax,%eax
80107b0f:	74 17                	je     80107b28 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b14:	8b 00                	mov    (%eax),%eax
80107b16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b1b:	89 04 24             	mov    %eax,(%esp)
80107b1e:	e8 44 fb ff ff       	call   80107667 <p2v>
80107b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b26:	eb 4b                	jmp    80107b73 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b2c:	74 0e                	je     80107b3c <walkpgdir+0x52>
80107b2e:	e8 4a b0 ff ff       	call   80102b7d <kalloc>
80107b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b3a:	75 07                	jne    80107b43 <walkpgdir+0x59>
      return 0;
80107b3c:	b8 00 00 00 00       	mov    $0x0,%eax
80107b41:	eb 47                	jmp    80107b8a <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b4a:	00 
80107b4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b52:	00 
80107b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b56:	89 04 24             	mov    %eax,(%esp)
80107b59:	e8 93 d5 ff ff       	call   801050f1 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b61:	89 04 24             	mov    %eax,(%esp)
80107b64:	e8 f1 fa ff ff       	call   8010765a <v2p>
80107b69:	83 c8 07             	or     $0x7,%eax
80107b6c:	89 c2                	mov    %eax,%edx
80107b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b71:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107b73:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b76:	c1 e8 0c             	shr    $0xc,%eax
80107b79:	25 ff 03 00 00       	and    $0x3ff,%eax
80107b7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b88:	01 d0                	add    %edx,%eax
}
80107b8a:	c9                   	leave  
80107b8b:	c3                   	ret    

80107b8c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b8c:	55                   	push   %ebp
80107b8d:	89 e5                	mov    %esp,%ebp
80107b8f:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107b92:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ba0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ba3:	01 d0                	add    %edx,%eax
80107ba5:	83 e8 01             	sub    $0x1,%eax
80107ba8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bb0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107bb7:	00 
80107bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80107bc2:	89 04 24             	mov    %eax,(%esp)
80107bc5:	e8 20 ff ff ff       	call   80107aea <walkpgdir>
80107bca:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bd1:	75 07                	jne    80107bda <mappages+0x4e>
      return -1;
80107bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bd8:	eb 48                	jmp    80107c22 <mappages+0x96>
    if(*pte & PTE_P)
80107bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bdd:	8b 00                	mov    (%eax),%eax
80107bdf:	83 e0 01             	and    $0x1,%eax
80107be2:	85 c0                	test   %eax,%eax
80107be4:	74 0c                	je     80107bf2 <mappages+0x66>
      panic("remap");
80107be6:	c7 04 24 84 8a 10 80 	movl   $0x80108a84,(%esp)
80107bed:	e8 48 89 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107bf2:	8b 45 18             	mov    0x18(%ebp),%eax
80107bf5:	0b 45 14             	or     0x14(%ebp),%eax
80107bf8:	83 c8 01             	or     $0x1,%eax
80107bfb:	89 c2                	mov    %eax,%edx
80107bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c00:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c08:	75 08                	jne    80107c12 <mappages+0x86>
      break;
80107c0a:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c0b:	b8 00 00 00 00       	mov    $0x0,%eax
80107c10:	eb 10                	jmp    80107c22 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c12:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c19:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c20:	eb 8e                	jmp    80107bb0 <mappages+0x24>
  return 0;
}
80107c22:	c9                   	leave  
80107c23:	c3                   	ret    

80107c24 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c24:	55                   	push   %ebp
80107c25:	89 e5                	mov    %esp,%ebp
80107c27:	53                   	push   %ebx
80107c28:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c2b:	e8 4d af ff ff       	call   80102b7d <kalloc>
80107c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c37:	75 0a                	jne    80107c43 <setupkvm+0x1f>
    return 0;
80107c39:	b8 00 00 00 00       	mov    $0x0,%eax
80107c3e:	e9 98 00 00 00       	jmp    80107cdb <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107c43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c4a:	00 
80107c4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c52:	00 
80107c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c56:	89 04 24             	mov    %eax,(%esp)
80107c59:	e8 93 d4 ff ff       	call   801050f1 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107c5e:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107c65:	e8 fd f9 ff ff       	call   80107667 <p2v>
80107c6a:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107c6f:	76 0c                	jbe    80107c7d <setupkvm+0x59>
    panic("PHYSTOP too high");
80107c71:	c7 04 24 8a 8a 10 80 	movl   $0x80108a8a,(%esp)
80107c78:	e8 bd 88 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c7d:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107c84:	eb 49                	jmp    80107ccf <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c89:	8b 48 0c             	mov    0xc(%eax),%ecx
80107c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8f:	8b 50 04             	mov    0x4(%eax),%edx
80107c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c95:	8b 58 08             	mov    0x8(%eax),%ebx
80107c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9b:	8b 40 04             	mov    0x4(%eax),%eax
80107c9e:	29 c3                	sub    %eax,%ebx
80107ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca3:	8b 00                	mov    (%eax),%eax
80107ca5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107ca9:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107cad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cb8:	89 04 24             	mov    %eax,(%esp)
80107cbb:	e8 cc fe ff ff       	call   80107b8c <mappages>
80107cc0:	85 c0                	test   %eax,%eax
80107cc2:	79 07                	jns    80107ccb <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107cc4:	b8 00 00 00 00       	mov    $0x0,%eax
80107cc9:	eb 10                	jmp    80107cdb <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ccb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107ccf:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107cd6:	72 ae                	jb     80107c86 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107cdb:	83 c4 34             	add    $0x34,%esp
80107cde:	5b                   	pop    %ebx
80107cdf:	5d                   	pop    %ebp
80107ce0:	c3                   	ret    

80107ce1 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107ce1:	55                   	push   %ebp
80107ce2:	89 e5                	mov    %esp,%ebp
80107ce4:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ce7:	e8 38 ff ff ff       	call   80107c24 <setupkvm>
80107cec:	a3 58 51 11 80       	mov    %eax,0x80115158
  switchkvm();
80107cf1:	e8 02 00 00 00       	call   80107cf8 <switchkvm>
}
80107cf6:	c9                   	leave  
80107cf7:	c3                   	ret    

80107cf8 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107cf8:	55                   	push   %ebp
80107cf9:	89 e5                	mov    %esp,%ebp
80107cfb:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107cfe:	a1 58 51 11 80       	mov    0x80115158,%eax
80107d03:	89 04 24             	mov    %eax,(%esp)
80107d06:	e8 4f f9 ff ff       	call   8010765a <v2p>
80107d0b:	89 04 24             	mov    %eax,(%esp)
80107d0e:	e8 3c f9 ff ff       	call   8010764f <lcr3>
}
80107d13:	c9                   	leave  
80107d14:	c3                   	ret    

80107d15 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d15:	55                   	push   %ebp
80107d16:	89 e5                	mov    %esp,%ebp
80107d18:	53                   	push   %ebx
80107d19:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107d1c:	e8 c6 d2 ff ff       	call   80104fe7 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d21:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d27:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d2e:	83 c2 08             	add    $0x8,%edx
80107d31:	89 d3                	mov    %edx,%ebx
80107d33:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d3a:	83 c2 08             	add    $0x8,%edx
80107d3d:	c1 ea 10             	shr    $0x10,%edx
80107d40:	89 d1                	mov    %edx,%ecx
80107d42:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d49:	83 c2 08             	add    $0x8,%edx
80107d4c:	c1 ea 18             	shr    $0x18,%edx
80107d4f:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d56:	67 00 
80107d58:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107d5f:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107d65:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d6c:	83 e1 f0             	and    $0xfffffff0,%ecx
80107d6f:	83 c9 09             	or     $0x9,%ecx
80107d72:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d78:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d7f:	83 c9 10             	or     $0x10,%ecx
80107d82:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d88:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d8f:	83 e1 9f             	and    $0xffffff9f,%ecx
80107d92:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107d98:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107d9f:	83 c9 80             	or     $0xffffff80,%ecx
80107da2:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107da8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107daf:	83 e1 f0             	and    $0xfffffff0,%ecx
80107db2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107db8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107dbf:	83 e1 ef             	and    $0xffffffef,%ecx
80107dc2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107dc8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107dcf:	83 e1 df             	and    $0xffffffdf,%ecx
80107dd2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107dd8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ddf:	83 c9 40             	or     $0x40,%ecx
80107de2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107de8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107def:	83 e1 7f             	and    $0x7f,%ecx
80107df2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107df8:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107dfe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e04:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e0b:	83 e2 ef             	and    $0xffffffef,%edx
80107e0e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e14:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e1a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e20:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e26:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e2d:	8b 52 08             	mov    0x8(%edx),%edx
80107e30:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e36:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e39:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107e40:	e8 df f7 ff ff       	call   80107624 <ltr>
  if(p->pgdir == 0)
80107e45:	8b 45 08             	mov    0x8(%ebp),%eax
80107e48:	8b 40 04             	mov    0x4(%eax),%eax
80107e4b:	85 c0                	test   %eax,%eax
80107e4d:	75 0c                	jne    80107e5b <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107e4f:	c7 04 24 9b 8a 10 80 	movl   $0x80108a9b,(%esp)
80107e56:	e8 df 86 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5e:	8b 40 04             	mov    0x4(%eax),%eax
80107e61:	89 04 24             	mov    %eax,(%esp)
80107e64:	e8 f1 f7 ff ff       	call   8010765a <v2p>
80107e69:	89 04 24             	mov    %eax,(%esp)
80107e6c:	e8 de f7 ff ff       	call   8010764f <lcr3>
  popcli();
80107e71:	e8 b5 d1 ff ff       	call   8010502b <popcli>
}
80107e76:	83 c4 14             	add    $0x14,%esp
80107e79:	5b                   	pop    %ebx
80107e7a:	5d                   	pop    %ebp
80107e7b:	c3                   	ret    

80107e7c <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e7c:	55                   	push   %ebp
80107e7d:	89 e5                	mov    %esp,%ebp
80107e7f:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107e82:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107e89:	76 0c                	jbe    80107e97 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107e8b:	c7 04 24 af 8a 10 80 	movl   $0x80108aaf,(%esp)
80107e92:	e8 a3 86 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107e97:	e8 e1 ac ff ff       	call   80102b7d <kalloc>
80107e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107e9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ea6:	00 
80107ea7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107eae:	00 
80107eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb2:	89 04 24             	mov    %eax,(%esp)
80107eb5:	e8 37 d2 ff ff       	call   801050f1 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebd:	89 04 24             	mov    %eax,(%esp)
80107ec0:	e8 95 f7 ff ff       	call   8010765a <v2p>
80107ec5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107ecc:	00 
80107ecd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107ed1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ed8:	00 
80107ed9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ee0:	00 
80107ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee4:	89 04 24             	mov    %eax,(%esp)
80107ee7:	e8 a0 fc ff ff       	call   80107b8c <mappages>
  memmove(mem, init, sz);
80107eec:	8b 45 10             	mov    0x10(%ebp),%eax
80107eef:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efd:	89 04 24             	mov    %eax,(%esp)
80107f00:	e8 bb d2 ff ff       	call   801051c0 <memmove>
}
80107f05:	c9                   	leave  
80107f06:	c3                   	ret    

80107f07 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f07:	55                   	push   %ebp
80107f08:	89 e5                	mov    %esp,%ebp
80107f0a:	53                   	push   %ebx
80107f0b:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f11:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f16:	85 c0                	test   %eax,%eax
80107f18:	74 0c                	je     80107f26 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107f1a:	c7 04 24 cc 8a 10 80 	movl   $0x80108acc,(%esp)
80107f21:	e8 14 86 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f2d:	e9 a9 00 00 00       	jmp    80107fdb <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f35:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f38:	01 d0                	add    %edx,%eax
80107f3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f41:	00 
80107f42:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f46:	8b 45 08             	mov    0x8(%ebp),%eax
80107f49:	89 04 24             	mov    %eax,(%esp)
80107f4c:	e8 99 fb ff ff       	call   80107aea <walkpgdir>
80107f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f58:	75 0c                	jne    80107f66 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107f5a:	c7 04 24 ef 8a 10 80 	movl   $0x80108aef,(%esp)
80107f61:	e8 d4 85 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f69:	8b 00                	mov    (%eax),%eax
80107f6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f70:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f76:	8b 55 18             	mov    0x18(%ebp),%edx
80107f79:	29 c2                	sub    %eax,%edx
80107f7b:	89 d0                	mov    %edx,%eax
80107f7d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f82:	77 0f                	ja     80107f93 <loaduvm+0x8c>
      n = sz - i;
80107f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f87:	8b 55 18             	mov    0x18(%ebp),%edx
80107f8a:	29 c2                	sub    %eax,%edx
80107f8c:	89 d0                	mov    %edx,%eax
80107f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f91:	eb 07                	jmp    80107f9a <loaduvm+0x93>
    else
      n = PGSIZE;
80107f93:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9d:	8b 55 14             	mov    0x14(%ebp),%edx
80107fa0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fa6:	89 04 24             	mov    %eax,(%esp)
80107fa9:	e8 b9 f6 ff ff       	call   80107667 <p2v>
80107fae:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107fb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107fb5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fbd:	8b 45 10             	mov    0x10(%ebp),%eax
80107fc0:	89 04 24             	mov    %eax,(%esp)
80107fc3:	e8 04 9e ff ff       	call   80101dcc <readi>
80107fc8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fcb:	74 07                	je     80107fd4 <loaduvm+0xcd>
      return -1;
80107fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fd2:	eb 18                	jmp    80107fec <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107fd4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fe1:	0f 82 4b ff ff ff    	jb     80107f32 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fec:	83 c4 24             	add    $0x24,%esp
80107fef:	5b                   	pop    %ebx
80107ff0:	5d                   	pop    %ebp
80107ff1:	c3                   	ret    

80107ff2 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ff2:	55                   	push   %ebp
80107ff3:	89 e5                	mov    %esp,%ebp
80107ff5:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107ff8:	8b 45 10             	mov    0x10(%ebp),%eax
80107ffb:	85 c0                	test   %eax,%eax
80107ffd:	79 0a                	jns    80108009 <allocuvm+0x17>
    return 0;
80107fff:	b8 00 00 00 00       	mov    $0x0,%eax
80108004:	e9 c1 00 00 00       	jmp    801080ca <allocuvm+0xd8>
  if(newsz < oldsz)
80108009:	8b 45 10             	mov    0x10(%ebp),%eax
8010800c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010800f:	73 08                	jae    80108019 <allocuvm+0x27>
    return oldsz;
80108011:	8b 45 0c             	mov    0xc(%ebp),%eax
80108014:	e9 b1 00 00 00       	jmp    801080ca <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108021:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108029:	e9 8d 00 00 00       	jmp    801080bb <allocuvm+0xc9>
    mem = kalloc();
8010802e:	e8 4a ab ff ff       	call   80102b7d <kalloc>
80108033:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010803a:	75 2c                	jne    80108068 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
8010803c:	c7 04 24 0d 8b 10 80 	movl   $0x80108b0d,(%esp)
80108043:	e8 58 83 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108048:	8b 45 0c             	mov    0xc(%ebp),%eax
8010804b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010804f:	8b 45 10             	mov    0x10(%ebp),%eax
80108052:	89 44 24 04          	mov    %eax,0x4(%esp)
80108056:	8b 45 08             	mov    0x8(%ebp),%eax
80108059:	89 04 24             	mov    %eax,(%esp)
8010805c:	e8 6b 00 00 00       	call   801080cc <deallocuvm>
      return 0;
80108061:	b8 00 00 00 00       	mov    $0x0,%eax
80108066:	eb 62                	jmp    801080ca <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108068:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010806f:	00 
80108070:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108077:	00 
80108078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010807b:	89 04 24             	mov    %eax,(%esp)
8010807e:	e8 6e d0 ff ff       	call   801050f1 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108083:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108086:	89 04 24             	mov    %eax,(%esp)
80108089:	e8 cc f5 ff ff       	call   8010765a <v2p>
8010808e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108091:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108098:	00 
80108099:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010809d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080a4:	00 
801080a5:	89 54 24 04          	mov    %edx,0x4(%esp)
801080a9:	8b 45 08             	mov    0x8(%ebp),%eax
801080ac:	89 04 24             	mov    %eax,(%esp)
801080af:	e8 d8 fa ff ff       	call   80107b8c <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801080b4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080be:	3b 45 10             	cmp    0x10(%ebp),%eax
801080c1:	0f 82 67 ff ff ff    	jb     8010802e <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801080c7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080ca:	c9                   	leave  
801080cb:	c3                   	ret    

801080cc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080cc:	55                   	push   %ebp
801080cd:	89 e5                	mov    %esp,%ebp
801080cf:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080d2:	8b 45 10             	mov    0x10(%ebp),%eax
801080d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080d8:	72 08                	jb     801080e2 <deallocuvm+0x16>
    return oldsz;
801080da:	8b 45 0c             	mov    0xc(%ebp),%eax
801080dd:	e9 a4 00 00 00       	jmp    80108186 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801080e2:	8b 45 10             	mov    0x10(%ebp),%eax
801080e5:	05 ff 0f 00 00       	add    $0xfff,%eax
801080ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080f2:	e9 80 00 00 00       	jmp    80108177 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108101:	00 
80108102:	89 44 24 04          	mov    %eax,0x4(%esp)
80108106:	8b 45 08             	mov    0x8(%ebp),%eax
80108109:	89 04 24             	mov    %eax,(%esp)
8010810c:	e8 d9 f9 ff ff       	call   80107aea <walkpgdir>
80108111:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108114:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108118:	75 09                	jne    80108123 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010811a:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108121:	eb 4d                	jmp    80108170 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108126:	8b 00                	mov    (%eax),%eax
80108128:	83 e0 01             	and    $0x1,%eax
8010812b:	85 c0                	test   %eax,%eax
8010812d:	74 41                	je     80108170 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
8010812f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108132:	8b 00                	mov    (%eax),%eax
80108134:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108139:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010813c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108140:	75 0c                	jne    8010814e <deallocuvm+0x82>
        panic("kfree");
80108142:	c7 04 24 25 8b 10 80 	movl   $0x80108b25,(%esp)
80108149:	e8 ec 83 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
8010814e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108151:	89 04 24             	mov    %eax,(%esp)
80108154:	e8 0e f5 ff ff       	call   80107667 <p2v>
80108159:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010815c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010815f:	89 04 24             	mov    %eax,(%esp)
80108162:	e8 7d a9 ff ff       	call   80102ae4 <kfree>
      *pte = 0;
80108167:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010816a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108170:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010817d:	0f 82 74 ff ff ff    	jb     801080f7 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108183:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108186:	c9                   	leave  
80108187:	c3                   	ret    

80108188 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108188:	55                   	push   %ebp
80108189:	89 e5                	mov    %esp,%ebp
8010818b:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010818e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108192:	75 0c                	jne    801081a0 <freevm+0x18>
    panic("freevm: no pgdir");
80108194:	c7 04 24 2b 8b 10 80 	movl   $0x80108b2b,(%esp)
8010819b:	e8 9a 83 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081a7:	00 
801081a8:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801081af:	80 
801081b0:	8b 45 08             	mov    0x8(%ebp),%eax
801081b3:	89 04 24             	mov    %eax,(%esp)
801081b6:	e8 11 ff ff ff       	call   801080cc <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801081bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081c2:	eb 48                	jmp    8010820c <freevm+0x84>
    if(pgdir[i] & PTE_P){
801081c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081ce:	8b 45 08             	mov    0x8(%ebp),%eax
801081d1:	01 d0                	add    %edx,%eax
801081d3:	8b 00                	mov    (%eax),%eax
801081d5:	83 e0 01             	and    $0x1,%eax
801081d8:	85 c0                	test   %eax,%eax
801081da:	74 2c                	je     80108208 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081e6:	8b 45 08             	mov    0x8(%ebp),%eax
801081e9:	01 d0                	add    %edx,%eax
801081eb:	8b 00                	mov    (%eax),%eax
801081ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081f2:	89 04 24             	mov    %eax,(%esp)
801081f5:	e8 6d f4 ff ff       	call   80107667 <p2v>
801081fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801081fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108200:	89 04 24             	mov    %eax,(%esp)
80108203:	e8 dc a8 ff ff       	call   80102ae4 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108208:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010820c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108213:	76 af                	jbe    801081c4 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108215:	8b 45 08             	mov    0x8(%ebp),%eax
80108218:	89 04 24             	mov    %eax,(%esp)
8010821b:	e8 c4 a8 ff ff       	call   80102ae4 <kfree>
}
80108220:	c9                   	leave  
80108221:	c3                   	ret    

80108222 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108222:	55                   	push   %ebp
80108223:	89 e5                	mov    %esp,%ebp
80108225:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108228:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010822f:	00 
80108230:	8b 45 0c             	mov    0xc(%ebp),%eax
80108233:	89 44 24 04          	mov    %eax,0x4(%esp)
80108237:	8b 45 08             	mov    0x8(%ebp),%eax
8010823a:	89 04 24             	mov    %eax,(%esp)
8010823d:	e8 a8 f8 ff ff       	call   80107aea <walkpgdir>
80108242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108249:	75 0c                	jne    80108257 <clearpteu+0x35>
    panic("clearpteu");
8010824b:	c7 04 24 3c 8b 10 80 	movl   $0x80108b3c,(%esp)
80108252:	e8 e3 82 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825a:	8b 00                	mov    (%eax),%eax
8010825c:	83 e0 fb             	and    $0xfffffffb,%eax
8010825f:	89 c2                	mov    %eax,%edx
80108261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108264:	89 10                	mov    %edx,(%eax)
}
80108266:	c9                   	leave  
80108267:	c3                   	ret    

80108268 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108268:	55                   	push   %ebp
80108269:	89 e5                	mov    %esp,%ebp
8010826b:	53                   	push   %ebx
8010826c:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010826f:	e8 b0 f9 ff ff       	call   80107c24 <setupkvm>
80108274:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010827b:	75 0a                	jne    80108287 <copyuvm+0x1f>
    return 0;
8010827d:	b8 00 00 00 00       	mov    $0x0,%eax
80108282:	e9 fd 00 00 00       	jmp    80108384 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108287:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010828e:	e9 d0 00 00 00       	jmp    80108363 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108296:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010829d:	00 
8010829e:	89 44 24 04          	mov    %eax,0x4(%esp)
801082a2:	8b 45 08             	mov    0x8(%ebp),%eax
801082a5:	89 04 24             	mov    %eax,(%esp)
801082a8:	e8 3d f8 ff ff       	call   80107aea <walkpgdir>
801082ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082b4:	75 0c                	jne    801082c2 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801082b6:	c7 04 24 46 8b 10 80 	movl   $0x80108b46,(%esp)
801082bd:	e8 78 82 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801082c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082c5:	8b 00                	mov    (%eax),%eax
801082c7:	83 e0 01             	and    $0x1,%eax
801082ca:	85 c0                	test   %eax,%eax
801082cc:	75 0c                	jne    801082da <copyuvm+0x72>
      panic("copyuvm: page not present");
801082ce:	c7 04 24 60 8b 10 80 	movl   $0x80108b60,(%esp)
801082d5:	e8 60 82 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801082da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082dd:	8b 00                	mov    (%eax),%eax
801082df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082ea:	8b 00                	mov    (%eax),%eax
801082ec:	25 ff 0f 00 00       	and    $0xfff,%eax
801082f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801082f4:	e8 84 a8 ff ff       	call   80102b7d <kalloc>
801082f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108300:	75 02                	jne    80108304 <copyuvm+0x9c>
      goto bad;
80108302:	eb 70                	jmp    80108374 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108304:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108307:	89 04 24             	mov    %eax,(%esp)
8010830a:	e8 58 f3 ff ff       	call   80107667 <p2v>
8010830f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108316:	00 
80108317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010831b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010831e:	89 04 24             	mov    %eax,(%esp)
80108321:	e8 9a ce ff ff       	call   801051c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108326:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108329:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010832c:	89 04 24             	mov    %eax,(%esp)
8010832f:	e8 26 f3 ff ff       	call   8010765a <v2p>
80108334:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108337:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010833b:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010833f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108346:	00 
80108347:	89 54 24 04          	mov    %edx,0x4(%esp)
8010834b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010834e:	89 04 24             	mov    %eax,(%esp)
80108351:	e8 36 f8 ff ff       	call   80107b8c <mappages>
80108356:	85 c0                	test   %eax,%eax
80108358:	79 02                	jns    8010835c <copyuvm+0xf4>
      goto bad;
8010835a:	eb 18                	jmp    80108374 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010835c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108366:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108369:	0f 82 24 ff ff ff    	jb     80108293 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010836f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108372:	eb 10                	jmp    80108384 <copyuvm+0x11c>

bad:
  freevm(d);
80108374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108377:	89 04 24             	mov    %eax,(%esp)
8010837a:	e8 09 fe ff ff       	call   80108188 <freevm>
  return 0;
8010837f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108384:	83 c4 44             	add    $0x44,%esp
80108387:	5b                   	pop    %ebx
80108388:	5d                   	pop    %ebp
80108389:	c3                   	ret    

8010838a <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010838a:	55                   	push   %ebp
8010838b:	89 e5                	mov    %esp,%ebp
8010838d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108390:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108397:	00 
80108398:	8b 45 0c             	mov    0xc(%ebp),%eax
8010839b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010839f:	8b 45 08             	mov    0x8(%ebp),%eax
801083a2:	89 04 24             	mov    %eax,(%esp)
801083a5:	e8 40 f7 ff ff       	call   80107aea <walkpgdir>
801083aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b0:	8b 00                	mov    (%eax),%eax
801083b2:	83 e0 01             	and    $0x1,%eax
801083b5:	85 c0                	test   %eax,%eax
801083b7:	75 07                	jne    801083c0 <uva2ka+0x36>
    return 0;
801083b9:	b8 00 00 00 00       	mov    $0x0,%eax
801083be:	eb 25                	jmp    801083e5 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801083c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c3:	8b 00                	mov    (%eax),%eax
801083c5:	83 e0 04             	and    $0x4,%eax
801083c8:	85 c0                	test   %eax,%eax
801083ca:	75 07                	jne    801083d3 <uva2ka+0x49>
    return 0;
801083cc:	b8 00 00 00 00       	mov    $0x0,%eax
801083d1:	eb 12                	jmp    801083e5 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801083d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d6:	8b 00                	mov    (%eax),%eax
801083d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083dd:	89 04 24             	mov    %eax,(%esp)
801083e0:	e8 82 f2 ff ff       	call   80107667 <p2v>
}
801083e5:	c9                   	leave  
801083e6:	c3                   	ret    

801083e7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083e7:	55                   	push   %ebp
801083e8:	89 e5                	mov    %esp,%ebp
801083ea:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083ed:	8b 45 10             	mov    0x10(%ebp),%eax
801083f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801083f3:	e9 87 00 00 00       	jmp    8010847f <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801083f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801083fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108403:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108406:	89 44 24 04          	mov    %eax,0x4(%esp)
8010840a:	8b 45 08             	mov    0x8(%ebp),%eax
8010840d:	89 04 24             	mov    %eax,(%esp)
80108410:	e8 75 ff ff ff       	call   8010838a <uva2ka>
80108415:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108418:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010841c:	75 07                	jne    80108425 <copyout+0x3e>
      return -1;
8010841e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108423:	eb 69                	jmp    8010848e <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108425:	8b 45 0c             	mov    0xc(%ebp),%eax
80108428:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010842b:	29 c2                	sub    %eax,%edx
8010842d:	89 d0                	mov    %edx,%eax
8010842f:	05 00 10 00 00       	add    $0x1000,%eax
80108434:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010843a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010843d:	76 06                	jbe    80108445 <copyout+0x5e>
      n = len;
8010843f:	8b 45 14             	mov    0x14(%ebp),%eax
80108442:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108445:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010844b:	29 c2                	sub    %eax,%edx
8010844d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108450:	01 c2                	add    %eax,%edx
80108452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108455:	89 44 24 08          	mov    %eax,0x8(%esp)
80108459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108460:	89 14 24             	mov    %edx,(%esp)
80108463:	e8 58 cd ff ff       	call   801051c0 <memmove>
    len -= n;
80108468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846b:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010846e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108471:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108474:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108477:	05 00 10 00 00       	add    $0x1000,%eax
8010847c:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010847f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108483:	0f 85 6f ff ff ff    	jne    801083f8 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108489:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010848e:	c9                   	leave  
8010848f:	c3                   	ret    